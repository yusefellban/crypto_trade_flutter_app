import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_nav_wrapper.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/services/preference_service.dart';
import 'logic/cubits/auth/auth_cubit.dart';

import 'core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const CryptoTradeApp());
}

class CryptoTradeApp extends StatelessWidget {
  const CryptoTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferenceService = di.sl<PreferenceService>();
    
    Widget initialScreen;
    if (!preferenceService.isOnboardingComplete()) {
      initialScreen = const OnboardingScreen();
    } else if (!preferenceService.isLoggedIn()) {
      initialScreen = const AuthScreen();
    } else {
      initialScreen = const MainNavWrapper();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          fontFamily: 'Inter',
        ),

        home: initialScreen,
      ),
    );
  }
}