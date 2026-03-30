import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 10),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: AppColors.inputBackground,
            suffixIcon: isPassword
                ? Icon(Icons.visibility_off_outlined, color: Colors.grey[700])
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}