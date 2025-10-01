import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart' as my_auth;
import 'package:appdev/presentation/widgets/custom_text_field.dart';
import 'package:appdev/presentation/widgets/auth_button.dart';
import 'package:appdev/presentation/widgets/divider.dart';
import 'package:appdev/presentation/widgets/loading_widget.dart';
import 'package:appdev/presentation/widgets/dialog/app_quick_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

 Future<void> _login(my_auth.AuthProvider auth) async {
  if (_formKey.currentState!.validate()) {
    try {
      await auth.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
    } catch (e) {
      if (mounted) {
        AppQuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Login Failed",
          text: e.toString(),
          confirmBtnText: "OK",
          confirmBtnColor: const Color(0xFFFF7A30),
        );
      }
    }
  }
}


  Future<void> _signInWithGoogle(my_auth.AuthProvider auth) async {
  try {
    await auth.signInWithGoogle();
  } catch (e) {
    if (mounted) {
      AppQuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Google Sign-in Failed",
        text: e.toString(),
        confirmBtnText: "OK",
        confirmBtnColor: Colors.red,
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<my_auth.AuthProvider>();

    return AppStateHandler(
      isLoading: auth.isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/main_logo.png',
                      height: 200,
                      color: const Color.fromARGB(255, 113, 52, 2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 113, 52, 2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    CustomTextField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email_outlined,
                      validator: (v) => v!.isEmpty ? "Enter your email" : null,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    CustomTextField(
                      controller: passwordCtrl,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                          v!.isEmpty ? "Enter your password" : null,
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Get.to(() => const ForgotPasswordScreen()),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF493628),
                        ),
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Button
                    AuthButton(
                      label: "Login",
                      isLoading: auth.isLoading,
                      onPressed: () => _login(auth),
                    ),
                    const SizedBox(height: 20),

                    // Sign up redirect
                    TextButton(
                      onPressed: () => Get.to(() => const SignUpScreen()),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF493628),
                      ),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                    const SizedBox(height: 16),

                    const DividerWithText(text: "or sign in with"),
                    const SizedBox(height: 24),

                    // Google Sign In
                    IconButton(
                      icon: Image.asset('assets/search.png', height: 32),
                      onPressed: () => _signInWithGoogle(auth),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
