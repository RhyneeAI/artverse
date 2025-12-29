import 'package:artverse/controllers/category_controller.dart';
import 'package:artverse/controllers/news_controller.dart';
import 'package:artverse/models/category_model.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/screens/choosed_topic_screen.dart';
import 'package:artverse/screens/search_screen.dart';
import 'package:artverse/widgets/category_tab_section.dart';
import 'package:artverse/widgets/news_card_widget.dart';
import 'package:artverse/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _newsController = NewsController();
  final _categoryController = CategoryController();

  List<CategoryModel> _categories = [];
  List<NewsModel> _allNews = [];
  List<NewsModel> _popularNews = [];

  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    _loadData();

    Future.delayed(Duration(milliseconds: 3000), () {
      if(mounted) {
        setState(() => _showSkeleton = false);
      }
    });
  }

  void _loadData() async {
    final categories = await _categoryController.getCategories();
    final newsData = await _newsController.getHomeNewsData();

    setState(() {
      _categories = categories;
      _allNews = newsData['allNews'];
      _popularNews = newsData['popularNews'];
    });

    // print("skeleton: ${_showSkeleton}");
    // print("newsIsLoad: ${_newsController.isLoading}");

    print("asdsa:${_popularNews[0].title}");
  }

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
                  _loadData();
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
                      itemCount: _popularNews.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (_, index) => NewsCard(news: _popularNews[index], isLoading: _newsController.isLoading || _showSkeleton),
                    ),
              ),
              const SizedBox(height: 24),
              CategoryTabSection(
                categories: _categories,
                allNews: _allNews,
                isLoading: _newsController.isLoading || _showSkeleton,
              ),
            ],
          ),
        )
      ),
    );
  }
}