import 'package:artverse/screen/choosed_topic_screen.dart';
import 'package:artverse/screen/search_screen.dart';
import 'package:artverse/widget/category_tab_section.dart';
import 'package:artverse/widget/news_card_widget.dart';
import 'package:artverse/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final List<Map<String, String>> newsList = [
  {
    'category': 'Europe',
    'title': 'Russian-Ukraine War: What to know about the conflict',
    'source': 'BBC News',
    'time': '2 hours ago',
    'logo': 'assets/images/dummy/bbc.png',
    'image': 'assets/images/dummy/news_head.png',
  },
  {
    'category': 'Technology',
    'title': 'AI is transforming digital art and creativity',
    'source': 'CNN',
    'time': '1 hour ago',
    'logo': 'assets/images/dummy/bbc.png',
    'image': 'assets/images/dummy/news_1.png',
  },
  {
    'category': 'Science',
    'title': 'NASA reveals new images from deep space',
    'source': 'National Geographic',
    'time': '30 min ago',
    'logo': 'assets/images/dummy/bbc.png',
    'image': 'assets/images/dummy/news_3.png',
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SearchBarWidget(
              controller: _searchController,
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
              onFilterTap: () async{
              final result = await Navigator.push<Set<String>>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChooseTopicsScreen(),
                ),
              );

              if (result != null) {
                print(result); // topic terpilih
              }
              },
            ),
            const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return NewsCard(
                      category: news['category'] ?? '',
                      title: news['title'] ?? '',
                      source: news['source'] ?? '',
                      timeAgo: news['time'] ?? '',
                      sourceLogo: news['logo'] ?? '',
                      bannerImage: news['image'] ?? '',
                      onTap: () {
                        // TODO: open detail page
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              CategoryTabSection(),
            ],
          ),
        )
      ),
    );
  }
}