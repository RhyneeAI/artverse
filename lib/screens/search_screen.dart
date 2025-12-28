import 'package:artverse/controllers/news_controller.dart';
import 'package:artverse/models/news_model.dart';
import 'package:artverse/screens/choosed_topic_screen.dart';
import 'package:artverse/screens/news_detail_screen.dart';
import 'package:artverse/utils/search_history.dart';
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsController _newsController = NewsController();
  
  List<NewsModel> _searchResults = [];
  List<String> _recentSearches = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await SearchHistoryUtils.getHistory();
    setState(() => _recentSearches = history);
  }

  void _onSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() => _isSearching = true);
    final results = await _newsController.searchNews(query);
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onChanged: (query) {
                _onSearch(query);
              },
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildRecentSearch()
                  : _isSearching
                      ? Center(child: CircularProgressIndicator())
                      : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearch() {
    if (_recentSearches.isEmpty) {
      return Center(child: Text('No recent searches'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent searches', style: TextStyle(fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () async {
                await SearchHistoryUtils.clearHistory();
                _loadHistory();
              },
              child: Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: _recentSearches.map((item) {
            return ActionChip(
              label: Text(item),
              onPressed: () {
                _searchController.text = item;
                _onSearch(item);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_searchResults.isEmpty) {
      return Center(child: Text('No results found'));
    }
    
    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final news = _searchResults[index];
        return ListTile(
          leading: Image.network(news.newsImageUrl.toString()),
          title: Text(news.title.toString()),
          subtitle: Text(news.category!.name.toString()),
          onTap: () async {
            await SearchHistoryUtils.addSearch(_searchController.text.trim());
            _loadHistory();
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewsDetailScreen(news: news),
              ),
            );
          },
        );
      },
    );
  }
}