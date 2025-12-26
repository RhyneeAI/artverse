class NewsArticle {
  final String id;
  final String category; // Sekarang berisi negara
  final String title;
  final String? description;
  final String? imageUrl;
  final String source;
  final String time;
  final bool isPremium;

  NewsArticle({
    required this.id,
    required this.category,
    required this.title,
    this.description,
    this.imageUrl,
    required this.source,
    required this.time,
    required this.isPremium,
  });

  factory NewsArticle.fromEuropeanaJson(Map<String, dynamic> json) {
    // Ambil title
    final titleList = json['title'] as List<dynamic>?;
    final title = titleList != null && titleList.isNotEmpty 
        ? (titleList.first as String?) ?? 'No Title'
        : 'No Title';
    
    // Ambil image URL dari edmPreview atau edmIsShownBy
    final previewList = json['edmPreview'] as List<dynamic>?;
    String? imageUrl;
    if (previewList != null && previewList.isNotEmpty) {
      final preview = previewList.first as String?;
      if (preview != null && preview.contains('thumbnail')) {
        try {
          imageUrl = Uri.decodeFull(preview.split('uri=')[1].split('&')[0]);
        } catch (e) {
          imageUrl = preview; // Fallback ke URL asli
        }
      }
    }
    
    // Ambil dataProvider sebagai source
    final providerList = json['dataProvider'] as List<dynamic>?;
    final source = providerList != null && providerList.isNotEmpty
        ? (providerList.first as String?) ?? 'Europeana'
        : 'Europeana';
    
    // AMBIL NEGARA SEBAGAI CATEGORY
    final countryList = json['country'] as List<dynamic>?;
    final category = countryList != null && countryList.isNotEmpty
        ? (countryList.first as String?) ?? 'Unknown Country'
        : 'Unknown Country';
    
    // Buat description dari dcDescription
    String? description;
    if (json['dcDescription'] != null) {
      final descList = json['dcDescription'] as List<dynamic>;
      if (descList.isNotEmpty) {
        description = descList.first as String?;
      }
    }
    
    return NewsArticle(
      id: json['id']?.toString() ?? '',
      category: category, // Pakai negara sebagai kategori
      title: title,
      description: description,
      imageUrl: imageUrl,
      source: source,
      time: _formatTimestamp(json),
      isPremium: false,
    );
  }

  static String _formatTimestamp(Map<String, dynamic> json) {
    final timestamp = json['timestamp_update_epoch'];
    if (timestamp != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp as int);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      }
    }
    return 'Recently added';
  }
}