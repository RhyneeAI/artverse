import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:artverse/models/news_model.dart';

class NewsController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

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
}