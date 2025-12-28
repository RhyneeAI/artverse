import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:artverse/models/category_model.dart';

class CategoryController {
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabase
        .from('categories')
        .select('id, name')
        .order('name');
      
      return response.map<CategoryModel>((item) {
        return CategoryModel(
          id: item['id']?.toString(),
          name: item['name']?.toString(),
        );
      }).toList();
    } catch (e) {
      print('Error get categories: $e');
      return [];
    }
  }
}