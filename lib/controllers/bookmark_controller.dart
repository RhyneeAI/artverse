import 'package:artverse/models/category_model.dart';
import 'package:artverse/models/news_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookmarkController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<bool> addBookmark(String newsId, String userId) async {
    try {
      final existing = await supabase
          .from('bookmarks')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', userId)
          .maybeSingle();

      // print("newsId ${newsId}");
      // print("userId ${userId}");
      // print("existing ${existing}");

      if (existing != null) {
        await supabase
            .from('bookmarks')
            .delete()
            .eq('news_id', newsId)
            .eq('user_id', userId);
            // print("result: ${result}");
        return false;
      } else {
        await supabase.from('bookmarks').insert({
          'news_id': newsId,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true;
      }
    } catch (e) {
      print('Toggle bookmark error: $e');
      rethrow;
    }
  }

  Future<List<NewsModel>> getBookmarkedNews(String userId) async {
    isLoading = true;
    try {
      final response = await supabase
          .from('bookmarks')
          .select('''
            news:news_id (
              *,
              news_image:news_image_id(image_url, image_name),
              category:category_id(id, name, icon),
              author:author_id(id, email, full_name),
              bookmarks:bookmarks(count)
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      // Extract news dari response
      final newsList = (response as List)
          .map((item) => item['news'])
          .whereType<Map<String, dynamic>>()
          .map<NewsModel>((item) => NewsModel.fromJson(item))
          .toList();
      
      return newsList;
    } finally {
      isLoading = false;
    }
  }
  
  // Get bookmarked news grouped by category
  Future<Map<String, dynamic>> getBookmarkedNewsGrouped(String userId) async {
    final allBookmarks = await getBookmarkedNews(userId);
    
    // Group by category
    final Map<String, List<NewsModel>> byCategory = {};
    for (final news in allBookmarks) {
      final categoryName = news.category?.name ?? 'Uncategorized';
      if (!byCategory.containsKey(categoryName)) {
        byCategory[categoryName] = [];
      }
      byCategory[categoryName]!.add(news);
    }
    
    // Get unique categories for tabs
    final categories = allBookmarks
        .map((news) => news.category)
        .whereType<CategoryModel>()
        .toSet()
        .toList();
    
    return {
      'allNews': allBookmarks,
      'byCategory': byCategory,
      'categories': categories,
    };
  }
}