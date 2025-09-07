import 'package:appdev/presentation/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class AuthProvider extends ChangeNotifier {
   final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const Wrapper());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  final bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

    Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const Wrapper());
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapErrorMessage(e));
    } on Exception {
      throw Exception("No internet connection. Please try again.");
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const Wrapper());
    print("User signed out");
    notifyListeners();
  }

  String _mapErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case "user-not-found":
        return "No user found for this email.";
      case "wrong-password":
        return "Invalid password.";
      case "invalid-email":
        return "This email address is invalid.";
      case "network-request-failed":
        return "No internet connection.";
      default:
        return "Login failed. Please try again.";
    }
  }
}

