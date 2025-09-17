import 'dart:convert';
import 'package:appdev/presentation/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:appdev/core/constants.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleUser = GoogleSignIn();
      await googleUser.signOut();
      final GoogleSignInAccount? googleUserWithUser = await GoogleSignIn()
          .signIn();

      if (googleUserWithUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUserWithUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      await _saveUserToDatabase();

      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await _saveUserToDatabase();

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
    notifyListeners();
  }

  Future<void> reset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> _saveUserToDatabase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}user_api/index.php?action=save"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firebase_uid": user.uid,
          "email": user.email,
          "name": user.displayName ?? "",
          "address": null,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("✅ SaveUser API Response: $data");
    } catch (e) {
      debugPrint("❌ Error saving user: $e");
    }
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
