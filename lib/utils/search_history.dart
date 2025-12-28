import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryUtils {
  static const String _key = 'search_history';
  static const int _maxHistory = 10;

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    List<String> history = await getHistory();
    
    // Remove duplicate
    history.remove(query);
    // Add to front
    history.insert(0, query);
    // Limit to max items
    if (history.length > _maxHistory) {
      history = history.sublist(0, _maxHistory);
    }
    
    await prefs.setStringList(_key, history);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}