import 'package:artverse/screen/choosed_topic_screen.dart';
import 'package:flutter/material.dart';
import '../widget/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> recentSearches = [
    'Technology',
    'Art',
    'Science',
    'Painting',
  ];

  final List<String> results = [];

  @override
  void initState() {
    super.initState();
    // Auto focus ketika masuk
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void _onSearch(String query) {
    // 🔍 Simulasi search
    setState(() {
      results.clear();
      if (query.isNotEmpty) {
        results.addAll(
          List.generate(
            5,
            (index) => '$query result ${index + 1}',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔍 SEARCH BAR
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearch,
              onFilterTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChooseTopicsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🧠 CONTENT
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildRecentSearch()
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= RECENT SEARCH =================

  Widget _buildRecentSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent searches',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: recentSearches.map((item) {
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

  // ================= SEARCH RESULT =================

  Widget _buildResults() {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            // TODO: open detail
          },
        );
      },
    );
  }
}
