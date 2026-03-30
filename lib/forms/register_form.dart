import 'package:flutter/material.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          key: const ValueKey("Register"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Sign up", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),

            SizedBox(height: 30),

            InputField(label: "Name", hint: "Enter name"),
            SizedBox(height: 20),

            InputField(label: "Email", hint: "Enter email"),
            SizedBox(height: 20),

            InputField(label: "Password", hint: "Enter password", isPassword: true),
            SizedBox(height: 20),

            InputField(label: "Confirm Password", hint: "Confirm password", isPassword: true),

            SizedBox(height: 40),

            MainButton(text: "Sign up"),

            SizedBox(height: 20),

            SocialButtons(),
          ],
        ),
      );

  }
}