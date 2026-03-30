import 'package:flutter/material.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';
import '../screens/settings_screen.dart';
import '../core/constants/app_strings.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          key: const ValueKey("Login"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(AppStrings.signIn, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),

            SizedBox(height: 40),

            InputField(label: AppStrings.email, hint: AppStrings.enterEmail),
            SizedBox(height: 20),

            InputField(label: AppStrings.password, hint: AppStrings.enterPassword, isPassword: true),

            SizedBox(height: 40),

            MainButton(
              text: AppStrings.signIn,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            SocialButtons(),
          ],
        ),
      );

  }
}