import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';
import '../core/constants/app_strings.dart';
import '../logic/cubits/auth/auth_cubit.dart';
import '../logic/cubits/auth/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Success registration, reset state and maybe move tab to Login or show alert
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful! Please login.")),
          );
          context.read<AuthCubit>().resetState();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          key: const ValueKey("Register"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.signUp, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            InputField(label: AppStrings.name, hint: AppStrings.enterName, controller: _nameController),
            const SizedBox(height: 20),
            InputField(label: AppStrings.email, hint: AppStrings.enterEmail, controller: _emailController),
            const SizedBox(height: 20),
            InputField(label: AppStrings.password, hint: AppStrings.enterPassword, isPassword: true, controller: _passwordController),
            const SizedBox(height: 20),
            InputField(label: AppStrings.confirmPassword, hint: AppStrings.enterConfirmPassword, isPassword: true, controller: _confirmPasswordController),
            const SizedBox(height: 40),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return MainButton(
                  text: state is AuthLoading ? "Signing up..." : AppStrings.signUp,
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Passwords do not match")),
                            );
                            return;
                          }
                          context.read<AuthCubit>().register(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                        },
                );
              },
            ),
            const SizedBox(height: 20),
            const SocialButtons(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}