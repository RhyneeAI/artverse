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

  Future<void> _loadBookmarks() async {
    setState(() {
      _categories = [];
      _bookmarkedNews = [];
    });

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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async { await _loadBookmarks(); },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Bookmarks',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _bookmarkedNews.isEmpty
                          ? Center(child: Text('No bookmarks yet'))
                          : CategoryTabSection(
                              categories: _categories,
                              allNews: _bookmarkedNews,
                              isLoading: false,
                              onBookmarkChanged: _loadBookmarks,
                            ),
                )
              ]
            )
          )
        )
      ),
    );
  }
}