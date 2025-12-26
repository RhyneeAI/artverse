import 'package:flutter/material.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/components/news_item_card.dart'; 

class HomeTab extends StatefulWidget {
  final List<NewsArticle> newsArticles;
  final bool isLoading;
  final VoidCallback onRefresh;

  const HomeTab({
    super.key,
    required this.newsArticles,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20),
            
            // News List
            Expanded(
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.newsArticles.isEmpty
                      ? _buildEmptyState()
                      : _buildNewsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[400]),
            const SizedBox(width: 12),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.separated(
      itemCount: widget.newsArticles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return NewsItemCard(article: widget.newsArticles[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No articles found',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}