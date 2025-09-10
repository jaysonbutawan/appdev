import 'package:appdev/presentation/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  

  Future<UserCredential> signInWithGoogle() async {
    
    await googleSignIn.initialize();
   final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
    if (googleUser == null) {
    throw Exception("Sign in aborted by user");
  }

   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

   final authClient = await googleSignIn.authorizationForScopes(['email', 'profile']);
  final String? accessToken = authClient?.accessToken;

  final credential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
    accessToken: accessToken,
  );


   return await _auth.signInWithCredential(credential);
}


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
    notifyListeners();
  }
  
Future<void> reset(String email) async {
  await _auth.sendPasswordResetEmail(email: email.trim());
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

