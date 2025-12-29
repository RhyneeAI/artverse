import 'package:artverse/models/category_model.dart';
import 'package:artverse/models/user_model.dart';

class NewsModel {
  final String? id;
  final String? title;
  final String? description;
  final String? source;
  final String? newsImageUrl;
  final int? totalVisit;
  final DateTime? createdAt;
  final bool? isBookmarked;
  
  // Relational data
  final CategoryModel? category;
  final UserModel? author;
  
  NewsModel({
    this.id,
    this.title,
    this.description,
    this.source,
    this.newsImageUrl,
    this.totalVisit,
    this.createdAt,
    this.category,
    this.author,
    this.isBookmarked
  });
  
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final bookmarksCount = (json['bookmarks'] as List?)?.firstOrNull?['count'] ?? 0;
    print(bookmarksCount);

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      newsImageUrl: json['news_image']?['image_url']?.toString() ?? '',
      totalVisit: int.tryParse(json['total_visit']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isBookmarked: bookmarksCount > 0,
      category: CategoryModel(
        id: json['category']?['id']?.toString(),
        name: json['category']?['name']?.toString(),
        icon: json['category']?['icon']?.toString(),
      ),
      author: UserModel(
        id: json['users']?['id']?.toString(),
        email: json['users']?['email']?.toString() ?? '',
        full_name: json['users']?['full_name']?.toString(),
      ),
    );
  }
}