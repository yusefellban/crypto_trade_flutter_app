import 'package:flutter/material.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';
import '../core/constants/app_strings.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          key: const ValueKey("Register"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.signUp, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            const InputField(label: AppStrings.name, hint: AppStrings.enterName),
            const SizedBox(height: 20),

            const InputField(label: AppStrings.email, hint: AppStrings.enterEmail),
            const SizedBox(height: 20),

            const InputField(label: AppStrings.password, hint: AppStrings.enterPassword, isPassword: true),
            const SizedBox(height: 20),

            const InputField(label: AppStrings.confirmPassword, hint: AppStrings.enterConfirmPassword, isPassword: true),

            const SizedBox(height: 40),

            const MainButton(text: AppStrings.signUp),

            const SizedBox(height: 20),

            const SocialButtons(),
          ],
        ),
      );

  }
}