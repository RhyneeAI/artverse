import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:artverse/models/news_model.dart';

class NewsController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final response = await supabase
          .from('news')
          .select('''
            *,
            news_image:news_image_id(image_url, image_name),
            category:category_id(id, name, icon),
            users:author_id(id, email, full_name)
            bookmarks:
          ''')
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return response.map<NewsModel>((item) => NewsModel.fromJson(item)).toList();
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  Future<void> incrementVisitCount(String newsId) async {
    try {
      final current = await supabase
        .from('news')
        .select('total_visit')
        .eq('id', newsId)
        .single();
      
      final currentVisit = current['total_visit'] ?? 0;
      
      // Increment
      await supabase
        .from('news')
        .update({'total_visit': currentVisit + 1})
        .eq('id', newsId);
        
    } catch (e) {
      print('Error increment visit: $e');
    }
  }

  Future<void> createNews({
    required String title,
    required String description,
    required String newsImageUrl,
    required String imageName,
    required String source,
    required String categoryId,
    required String authorId,
  }) async {
    isLoading = true;
    try {
      final imageResponse = await supabase
          .from('news_image')
          .insert({
            'image_name': imageName,
            'image_url': newsImageUrl,
          })
          .select('id')
          .single(); 
      
      final imageId = imageResponse['id'];

      await supabase.from('news').insert({
        'title': title,
        'description': description,
        'news_image_id': imageId, 
        'source': source,
        'category_id': categoryId,
        'author_id': authorId,
        'total_visit': 0,
      });
    } finally {
      isLoading = false;
    }
  }

  // Upload image ke Supabase Storage
  Future<Map<String, String>?> uploadNewsImage(File imageFile) async {
    try {
      final fileName = 'news/arI${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await supabase.storage
          .from('Artverse')
          .upload(fileName, imageFile);
      
      final url = supabase.storage
          .from('Artverse')
          .getPublicUrl(fileName);
      
      return {
        'url': url,
        'fileName': fileName,
      };
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getHomeNewsData() async {
    isLoading = true;
    try {
      final user = supabase.auth.currentUser;

      final response = await supabase
          .from('news')
          .select('''
            *,
            news_image:news_image_id(image_url, image_name),
            category:category_id(id, name, icon),
            users:author_id(id, email, full_name),
            bookmarks:bookmarks(count)
          ''')
          .eq('bookmarks.user_id', user!.id)
          .order('created_at', ascending: false);

      final allNewsList = (response as List)
          .map<NewsModel>((item) => NewsModel.fromJson(item))
          .toList();
      // print("response : ${allNewsList[0].isBookmarked}");

      final popularNews = List<NewsModel>.from(allNewsList);
      popularNews.sort((a, b) => b.totalVisit!.compareTo(a.totalVisit!));

      final hasPopular = popularNews.any((news) => news.totalVisit! > 0);

      if (!hasPopular) {
        popularNews.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }

      return {
        'allNews': allNewsList,
        'popularNews': popularNews.take(3).toList(),
      };
    } catch (e) {
      print('Get home data error: $e');
      return {
        'allNews': [],
        'popularNews': [],
      };
    } finally {
      isLoading = false;
    }
  }
}