import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:appdev/presentation/state/providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flutter_dash,
                    size: 80, color: Colors.blueAccent),
                const SizedBox(height: 20),
                Text("Welcome Back",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your email" : null,
                  onChanged: (value) => email.text = value,
                ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? "Enter your password" : null,
                    onChanged: (value) => password.text = value,
                  ),

                  // 👇 Put "Forgot Password" directly after password field
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      ),
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  auth.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox(height: 16),
                 ElevatedButton(
                    onPressed: context.read<AuthProvider>().isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<AuthProvider>().login(
                          email: email.text,
                          password: password.text,
                        );
                      }
                    },
                    
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Login", style: TextStyle(
                          fontSize: 18,  
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),),

                      ),
                      const SizedBox(height: 30),
                      TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen())
                          ),
                          child: const Text("Don't have an account? Sign Up"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
