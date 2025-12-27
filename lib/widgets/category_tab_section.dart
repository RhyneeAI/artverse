import 'package:flutter/material.dart';
import '../data/news_dummy.dart';
import 'news_list_view.dart';

class CategoryTabSection extends StatelessWidget {
  const CategoryTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🏷️ TAB BAR
          const TabBar(
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Digital'),
              Tab(text: 'Painting'),
              Tab(text: 'Sculpture'),
              Tab(text: 'Photography'),
            ],
          ),

          const SizedBox(height: 8),

          // 📃 TAB CONTENT
          SizedBox(
            height: 400, // penting kalau di dalam Column
            child: TabBarView(
              children: [
                NewsListView(newsList: dummyNews),
                NewsListView(newsList: dummyNews),
                NewsListView(newsList: dummyNews),
                NewsListView(newsList: dummyNews),
                NewsListView(newsList: dummyNews),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
