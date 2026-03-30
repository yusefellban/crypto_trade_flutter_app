import 'package:flutter/material.dart';
import '../../forms/login_form.dart';
import '../../forms/register_form.dart';
import '../../customWidget/custom_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String selectedTab = "login";

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
                  color: const Color(0xFF1A222B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: "Sign in",
                        isSelected: selectedTab == "login",
                        onTap: () => setState(() => selectedTab = "login"),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        title: "Sign up",
                        isSelected: selectedTab == "register",
                        onTap: () => setState(() => selectedTab = "register"),
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
                  child: selectedTab == "login"
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