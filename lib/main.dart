import 'package:artverse/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'; // Import tambahan
import 'package:flutter_localizations/flutter_localizations.dart'; // Import tambahan
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  // await FirebaseAppCheck.instance.activate(
    // providerAndroid: AndroidProvider.debug, 
  // );

  // await FirebaseAppCheck.instance.activate(
  //   providerAndroid: AndroidProvider.playIntegrity, // Production Android
  //   providerApple: AppleProvider.appAttest, // Production iOS
  // );
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtVerse',
      theme: ThemeData(primarySwatch: Colors.blue),
      // --- TAMBAHKAN KONFIGURASI INI ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate, // <-- YANG INI WAJIB
      ],
      supportedLocales: const [
        Locale('en'),
        // Locale('id'), // Uncomment jika mau tambah bahasa Indonesia
      ],
      // --- AKHIR KONFIGURASI ---
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}