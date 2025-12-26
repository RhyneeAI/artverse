import 'package:artverse/widget/category_tab_section.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: CategoryTabSection()),
          ],
        ),
      ),
    );
  }
}
