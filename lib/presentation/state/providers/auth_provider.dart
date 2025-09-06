import 'package:appdev/presentation/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Get.offAll(() => const Wrapper());

    // 👇 you can also save extra fields like fullName into Firestore later
    // await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
    //   'fullName': fullName,
    //   'email': email,
    // });

    return credential;
  }
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login({required String email, required String password}) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

