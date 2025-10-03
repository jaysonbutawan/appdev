import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/services/cart_service.dart';

Future<void> handleAddToCart(BuildContext context, String productId, String productName, {int quantity = 1, String? size}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in")),
      );
      return;
    }

    await addToCart(user.uid, productId, quantity,size);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$productName added to cart")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to add to cart: $e")),
    );
  }
}
