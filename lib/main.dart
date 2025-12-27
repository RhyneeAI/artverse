import 'package:artverse/screens/splash_screen.dart';
import 'package:artverse/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. SystemChrome dulu
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  
  // 2. SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // 3. Supabase
  await Supabase.initialize(
    url: 'https://xfxixuiqpbwemmvteznq.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmeGl4dWlxcGJ3ZW1tdnRlem5xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3NDgyODYsImV4cCI6MjA4MjMyNDI4Nn0.J67lgC0EzKaGBUGYwsswUXbB9QHQw1LzJJcA_SklgQA',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtVerse',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}