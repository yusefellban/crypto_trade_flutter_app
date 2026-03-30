import 'package:flutter/material.dart';
import '../../forms/login_form.dart';
import '../../forms/register_form.dart';
import '../../customWidget/custom_button.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String selectedTab = AppStrings.loginFlag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Toggle Buttons
              Container(
                height: 54,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: AppStrings.signIn,
                        isSelected: selectedTab == AppStrings.loginFlag,
                        onTap: () => setState(() => selectedTab = AppStrings.loginFlag),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        title: AppStrings.signUp,
                        isSelected: selectedTab == AppStrings.registerFlag,
                        onTap: () => setState(() => selectedTab = AppStrings.registerFlag),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Forms
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: selectedTab == AppStrings.loginFlag
                      ? const LoginForm()
                      : const RegisterForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}