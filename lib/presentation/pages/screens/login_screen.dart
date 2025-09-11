import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:appdev/presentation/state/providers/auth_provider.dart'as my_auth;
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
                  const Icon(Icons.flutter_dash,
                      size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 24),
                  Text("Welcome Back",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: password,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? "Enter your password" : null,
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                      Get.to(() => const ForgotPasswordScreen());
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.blueAccent),
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (auth.isLoading)
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              try {
                                await auth.login(
                                  email: email.text.trim(),
                                  password: password.text.trim(),
                                );
                              } catch (e) {
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red),
                                  );
                                }
                              }
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: (auth.isLoading)
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignUpScreen());
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent),
                    child: const Text("Don't have an account? Sign Up"),
                  ),

                      Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "or",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ElevatedButton(
                                onPressed: (auth.isLoading) ? null : () async {
                                  final scaffold = ScaffoldMessenger.of(context);
                                  try {
                                    UserCredential? userCredential = await auth.signInWithGoogle();
                                
                                      scaffold.showSnackBar(
                                        SnackBar(content: Text('Signed in as ${userCredential?.user?.email}')),
                                      );
                                   
                                  } on FirebaseAuthException catch (e) {
                                    scaffold.showSnackBar(
                                      SnackBar(content: Text(e.message ?? e.code), backgroundColor: Colors.red),
                                    );
                                  } catch (e) {
                                    scaffold.showSnackBar(
                                      SnackBar(content: Text('Sign-in failed: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: (auth.isLoading)
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2.5),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login), 
                                          SizedBox(width: 8),
                                          Text('Sign in with Google'),
                                        ],
                                      ),
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
