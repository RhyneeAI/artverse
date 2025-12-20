import 'package:artverse/auth/profile.dart';
import 'package:artverse/news/create_news.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtVerse Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                )
              );
            }, 
            icon: Icon(Icons.people)
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome! Berita Design di sini.'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateNewsScreen()),
                );
              },
              child: Text("Tambah Berita"),
            )
          ],
        )
      ),
      
    );
  }
}