import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart' as my_auth;
import 'package:get/get.dart';

import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:appdev/presentation/widgets/custom_text_field.dart';
import 'package:appdev/presentation/widgets/auth_button.dart';
import 'package:appdev/presentation/widgets/divider.dart';


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
    final messenger = ScaffoldMessenger.of(context);
    if (_formKey.currentState!.validate()) {
      try {
        await auth.login(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _signInWithGoogle(my_auth.AuthProvider auth) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      UserCredential? user = await auth.signInWithGoogle();
      messenger.showSnackBar(
        SnackBar(content: Text('Signed in as ${user?.user?.email}')),
      );
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.message ?? e.code),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<my_auth.AuthProvider>();

    return Scaffold(
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
                  const SizedBox(height: 5),
                  Image.asset('assets/applogo.png', height: 200, color: const Color(0xFFFF7A30)),
                  Text("Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailCtrl,
                    label: "Email",
                    icon: Icons.email_outlined,
                    validator: (v) => v!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: passwordCtrl,
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? "Enter your password" : null,
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  AuthButton(
                    label: "Login",
                    isLoading: auth.isLoading,
                    onPressed: () => _login(auth),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Get.to(() => const SignUpScreen()),
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                  const SizedBox(height: 16),

                  const DividerWithText(text: "or"),
                  const SizedBox(height: 24),

                  AuthButton(
                    label: "Sign in with Google",
                    icon: Image.asset('assets/search.png'),
                    bgColor: Colors.white,
                    textColor: Colors.black,
                    isLoading: auth.isLoading,
                    onPressed: () => _signInWithGoogle(auth),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
