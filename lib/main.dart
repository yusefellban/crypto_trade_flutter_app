import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';

void main() {
  runApp(const CryptoTradeApp());
}

class CryptoTradeApp extends StatelessWidget {
  const CryptoTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'Inter',
      ),

      home: const OnboardingScreen(),
    );
  }
}