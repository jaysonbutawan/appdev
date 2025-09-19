import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:appdev/data/services/auth_service.dart';
import 'package:appdev/presentation/pages/wrappers/wrapper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login({required String email, required String password}) async {
  _setLoading(true);
  try {
    final credential = await _authService.signInWithEmail(email, password);
    await _authService.saveUserToDatabase(credential.user!);
    Get.offAll(() => const Wrapper());
    notifyListeners();
  } on FirebaseAuthException catch (e) {
     String message = "Invalid credentials. Please try again.";
     if (e.code == "user-not-found"&& e.code == "wrong-password" && e.code == "invalid-email") {
       message ;
     }
    
    throw(message);
  } finally {
    _setLoading(false);
  }
}


  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential?.user != null) {
        await _authService.saveUserToDatabase(credential!.user!);
        Get.offAll(() => const Wrapper());
        notifyListeners(); 
      }
    } catch (e) {
      throw Exception("Google sign-in failed: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    Get.offAll(() => const Wrapper());
    notifyListeners();
  }

  Future<void> reset(String email) async {
    await _authService.auth.sendPasswordResetEmail(email: email.trim());
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

}
