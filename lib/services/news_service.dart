import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:artverse/models/news_model.dart';

class NewsService {
  static const String _baseUrl = 'https://api.europeana.eu/record/v2';
  static const String _apiKey = 'olistroot';
  final Logger _logger = Logger();

  Future<List<NewsArticle>> fetchNews() async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/search.json').replace(queryParameters: {
        'query': 'Vermeer', // Ganti dengan pencarian yang lebih spesifik
        'wskey': _apiKey,
        'qf': 'TYPE:IMAGE',
        'rows': '10',
        'profile': 'rich', // Dapatkan data lebih lengkap
        'media': 'true', // Pastikan ada media
      });

      _logger.i('🌐 Request URL: ${uri.toString().replaceAll(_apiKey, '***')}');
      
      final response = await http.get(uri);
      _logger.i('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Debug: Tampilkan struktur response
        _logger.d('📊 Response keys: ${data.keys.toList()}');
        _logger.d('📊 Total results: ${data['totalResults']}');
        
        final List<dynamic> items = data['items'] ?? [];
        _logger.w('📦 Items found: ${items.length}');
        
        if (items.isEmpty) {
          _logger.e('❌ No items found in response');
          return [];
        }

        // Log contoh item pertama
        _logger.v('🔍 First item structure (simplified):');
        final firstItem = items.first as Map<String, dynamic>;
        _logger.v('   ID: ${firstItem['id']}');
        _logger.v('   Title: ${firstItem['title']}');
        _logger.v('   Type: ${firstItem['type']}');
        _logger.v('   Has edmPreview: ${firstItem['edmPreview'] != null}');
        _logger.v('   Has edmIsShownBy: ${firstItem['edmIsShownBy'] != null}');
        _logger.v('   Provider: ${firstItem['dataProvider']}');
        _logger.v('   Country: ${firstItem['country']}');
        
        // Konversi menggunakan factory method baru
        return items.map((item) {
          try {
            return NewsArticle.fromEuropeanaJson(item as Map<String, dynamic>);
          } catch (e) {
            _logger.e('❌ Error parsing item: $e');
            return NewsArticle(
              id: 'error',
              category: 'Error',
              title: 'Failed to parse',
              source: 'Europeana',
              time: 'Now',
              isPremium: false,
            );
          }
        }).where((article) => article.id != 'error').toList();
        
      } else {
        _logger.e('❌ API Error ${response.statusCode}: ${response.body.substring(0, 100)}...');
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // _logger.e('🔥 Exception in fetchNews', e, stackTrace);
      throw Exception('Error fetching news: $e');
    }
  }

  // Untuk search dengan query spesifik
  Future<List<NewsArticle>> searchArt(String query) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl/search.json').replace(queryParameters: {
        'query': query,
        'wskey': _apiKey,
        'qf': 'TYPE:IMAGE AND what:"painting"', // Filter untuk lukisan
        'rows': '20',
        'profile': 'rich',
        'media': 'true',
        'reusability': 'open', // Hanya konten terbuka
      });

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        
        _logger.i('🔍 Search for "$query": Found ${items.length} items');
        
        return items.map((item) {
          return NewsArticle.fromEuropeanaJson(item as Map<String, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      _logger.e('Search error: $e');
      return [];
    }
  }
}