import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/presentation/widgets/custom_text_field.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart' as auth_provider;
import 'package:appdev/presentation/widgets/auth_button.dart';
import 'package:appdev/presentation/widgets/loading_widget.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _resetSent = false;
  final auth_provider.AuthProvider _authProvider = auth_provider.AuthProvider();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _authProvider.reset(_emailController.text);
        setState(() {
          _resetSent = true;
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset link sent to your email")),
        );
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);

        String errorMessage = "An error occurred. Please try again.";
        if (e.code == 'user-not-found') {
          errorMessage = "No account found with this email.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Please enter a valid email address.";
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppStateHandler(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_reset, size: 80, color: Color.fromARGB(255, 113, 52, 2)),
                  const SizedBox(height: 20),
                  Text("Reset Password",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color.fromARGB(255, 64, 29, 4),
                      )),
                  const SizedBox(height: 10),
                  Text(
                    _resetSent
                        ? "Check your email for a password reset link"
                        : "Enter your email to receive a password reset link",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),

                  if (!_resetSent) ...[
                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    AuthButton(
                      label: "Send Reset Link",
                      onPressed: _resetPassword,
                      isLoading: _isLoading,
                    ),
                  ] else ...[
                    const Icon(Icons.check_circle,
                        size: 60, color: Colors.green),
                    const SizedBox(height: 20),

                    AuthButton(
                      label: "Return to Login",
                      onPressed: () => Navigator.pop(context),
                      isLoading: false,
                    ),
                  ],

                  const SizedBox(height: 20),

                  if (!_resetSent)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF493628),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Back to Login"),
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
