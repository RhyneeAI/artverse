import 'package:supabase_flutter/supabase_flutter.dart';

class BookmarkController {
  final supabase = Supabase.instance.client;

  Future<bool> addBookmark(String newsId, String userId) async {
    try {
      final existing = await supabase
          .from('bookmarks')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        await supabase
            .from('bookmarks')
            .delete()
            .eq('news_id', newsId)
            .eq('user_id', userId);
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
}