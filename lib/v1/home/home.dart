import 'package:flutter/material.dart';
import 'package:artverse/v1/utils/constants.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/v1/services/news_service.dart';
import 'package:artverse/v1/components/bottom_navbar.dart'; // Import di sini
import 'package:artverse/v1/screens/tabs/home_tab.dart'; // Tab home dipisah
// import 'package:artverse/screens/tabs/explore_tab.dart';
// import 'package:artverse/screens/tabs/bookmark_tab.dart';
import 'package:artverse/screens/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<NewsArticle> _newsArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  // GUNAKAN GETTER - otomatis update ketika state berubah
  List<Widget> get _tabScreens {
    return [
      HomeTab(
        newsArticles: _newsArticles,
        isLoading: _isLoading,
        onRefresh: _fetchNews,
      ),
      const Placeholder(), // Buat file explore_tab.dart nanti
      const Placeholder(), // Buat file bookmark_tab.dart nanti
      const ProfileTab(),
    ];
  }

  Future<void> _fetchNews() async {
    try {
      setState(() => _isLoading = true);
      final newsService = NewsService();
      final articles = await newsService.fetchNews();
      
      setState(() {
        _newsArticles = articles;
        _isLoading = false;
        // TIDAK PERLU panggil _initializeTabScreens lagi
        // Getter otomatis pakai data terbaru
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load news: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _getCurrentTime(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: _tabScreens[_selectedIndex], 
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _showSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }
}

// Screen untuk search (buat file terpisah nanti)
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(
        child: Text('Search Screen'),
      ),
    );
  }
}