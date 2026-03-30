import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const CryptoTradeApp());
}

class CryptoTradeApp extends StatelessWidget {
  const CryptoTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Auth',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF11181F),
        primaryColor: const Color(0xFF60E0BA),
        fontFamily: 'Inter',
      ),

      home: const AuthScreen(),
    );
  }
}