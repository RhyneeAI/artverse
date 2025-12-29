// import 'package:artverse/widgets/category_tab_section.dart';
import 'package:artverse/controllers/auth_controller.dart';
import 'package:artverse/controllers/bookmark_controller.dart';
import 'package:artverse/models/category_model.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/widgets/category_tab_section.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkController _bookmarkController = BookmarkController();
  final AuthController _authController = AuthController();
  
  List<NewsModel> _bookmarkedNews = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    final user = await _authController.getCurrentUser();
    if (user?.id == null) return;
    
    setState(() => _isLoading = true);
    
    final data = await _bookmarkController.getBookmarkedNewsGrouped(user!.id!);
    
    setState(() {
      _bookmarkedNews = data['allNews'];
      _categories = data['categories'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async => _loadBookmarks,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _bookmarkedNews.isEmpty
                      ? Center(child: Text('No bookmarks yet'))
                      : CategoryTabSection(
                          categories: _categories,
                          allNews: _bookmarkedNews,
                          isLoading: false,
                        ),
            )
          )
        )
      ),
    );
  }
}