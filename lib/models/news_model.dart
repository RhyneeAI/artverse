class NewsModel {
  final int category_id;
  final int author_id;
  final String title;
  final String description;
  final String news_image;
  final String source;
  final String total_visit;
  String created_at;

  NewsModel({
    required this.category_id,
    required this.author_id,
    required this.title,
    required this.description,
    required this.news_image,
    required this.source,
    this.total_visit = '0',
    this.created_at = ''
  });
}
