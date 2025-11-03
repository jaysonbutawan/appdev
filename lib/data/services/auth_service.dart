import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:appdev/core/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); 
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
  

  Future<void> saveUserToDatabase(User user) async {
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
      debugPrint("SaveUser API Response: $data");
    } catch (e) {
      debugPrint("Error saving user: $e");
    }
  }

  Future<bool> updateUserName(String newName) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        debugPrint("No user is currently signed in.");
        return false;
      }

      await user.updateDisplayName(newName);
      await user.reload(); 

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}user_api/index.php?action=update_name"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firebase_uid": user.uid,
          "name": newName,
        }),
      );

      debugPrint(" Update name API Response: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint(" Name updated successfully on backend.");
        return true;
      } else {
        debugPrint("Backend failed to update name: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error updating user name: $e");
      return false;
    }
  }


  FirebaseAuth get auth => _auth;
}
