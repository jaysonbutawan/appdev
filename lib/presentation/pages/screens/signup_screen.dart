import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart';
import 'login_screen.dart';
import 'package:get/get.dart';
import 'package:appdev/presentation/widgets/custom_text_field.dart';
import 'package:appdev/presentation/widgets/auth_button.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (passwordCtrl.text != confirmPasswordCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );


        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Get.offAll(() => const LoginScreen());
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "An error occurred during sign up"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const SizedBox(height: 5),
                  Image.asset(
                    'assets/main_logo.png',
                    height: 200,
                    color: const Color.fromARGB(255, 113, 52, 2),
                  ),
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 113, 52, 2)),
                  ),
                  const SizedBox(height: 30),   

                  CustomTextField(
                    controller: emailCtrl,
                    label: "Email",
                    icon: Icons.email_outlined,
                    validator: (v) => v!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: passwordCtrl,
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) {
                      if (v!.isEmpty) return "Enter your password";
                      if (v.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: confirmPasswordCtrl,
                    label: "Confirm Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) =>
                        v!.isEmpty ? "Confirm your password" : null,
                  ),
                  const SizedBox(height: 34),

                  AuthButton(
                    label: "Sign Up",
                    isLoading: auth.isLoading,
                    onPressed: () => _signUp(),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF493628),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Already have an account? Login"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
