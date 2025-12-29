import 'package:artverse/models/category_model.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/widgets/news_list_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTabSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final List<NewsModel> allNews;
  final bool isLoading;
  final VoidCallback? onBookmarkChanged;
  
  const CategoryTabSection({
    super.key,
    required this.categories,
    required this.allNews,
    required this.isLoading,
    this.onBookmarkChanged
  });

  @override
  Widget build(BuildContext context) {
    final showSkeleton = isLoading;
    
    final allTabs = showSkeleton
        ? [
            Tab(child: _buildSkeletonTab()),
            Tab(child: _buildSkeletonTab()),
            Tab(child: _buildSkeletonTab()),
          ]
        : [
            Tab(text: 'All'),
            ...categories.map((cat) => Tab(text: cat.name ?? '')),
          ];

    return DefaultTabController(
      length: allTabs.length,
      child: Column(
        children: [
          TabBar(isScrollable: true, tabs: allTabs),
          
          SizedBox(
            height: 400,
            child: TabBarView(
              children: showSkeleton
                  ? List.generate(allTabs.length, (_) => NewsListView(isLoading: true))
                  : [
                      NewsListView(
                        newsList: allNews,
                        onBookmarkChanged: onBookmarkChanged,
                      ),
                      ...categories.map((category) {
                        final filteredNews = allNews.where(
                          (news) => news.category!.id == category.id
                        ).toList();
                        return NewsListView(
                          newsList: filteredNews,
                          onBookmarkChanged: onBookmarkChanged,
                        );
                      }).toList(),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonTab() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 80,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
      ),
    );
  }
}