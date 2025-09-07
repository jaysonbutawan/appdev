import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart'; 
import 'package:appdev/presentation/state/providers/auth_provider.dart';
import 'login_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController fullName = TextEditingController();

 Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'fullName': fullName.text.trim(),
          'email': email.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
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
                Text("Create Account",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 30),
                TextFormField(
                  controller: fullName,
                  decoration: const InputDecoration(labelText: "Full Name",
                  prefixIcon: Icon( Icons.person_outline),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your full name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: "Email",
                  prefixIcon: Icon( Icons.email_outlined),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your email" : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: password,
                  decoration: const InputDecoration(labelText: "Password",
                  prefixIcon: Icon( Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPassword,
                  decoration: const InputDecoration(labelText: "Confirm Password",
                  prefixIcon: Icon( Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Confirm your password" : null,
                ),
                const SizedBox(height: 20),
                auth.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: auth.isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign Up", 
                    style: TextStyle(
                      fontSize: 18,  
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                },
                child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}