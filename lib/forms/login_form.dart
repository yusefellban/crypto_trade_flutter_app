import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../customWidget/input_field.dart';
import '../customWidget/main_button.dart';
import '../customWidget/social_buttons.dart';
import '../screens/main_nav_wrapper.dart';
import '../core/constants/app_strings.dart';
import '../logic/cubits/auth/auth_cubit.dart';
import '../logic/cubits/auth/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavWrapper()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          key: const ValueKey("Login"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.signIn, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            InputField(
              label: AppStrings.email,
              hint: AppStrings.enterEmail,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            InputField(
              label: AppStrings.password,
              hint: AppStrings.enterPassword,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 40),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return MainButton(
                  text: state is AuthLoading ? "Logging in..." : AppStrings.signIn,
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthCubit>().login(
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}