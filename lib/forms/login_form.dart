import 'package:flutter/material.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          key: const ValueKey("Login"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Sign in", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),

            SizedBox(height: 40),

            InputField(label: "Email", hint: "Enter your email"),
            SizedBox(height: 20),

            InputField(label: "Password", hint: "Enter password", isPassword: true),

            SizedBox(height: 40),

            MainButton(text: "Sign in"),

            SizedBox(height: 20),

            SocialButtons(),
          ],
        ),
      );

  }
}