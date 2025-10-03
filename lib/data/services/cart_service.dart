import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

final cartApi = ApiService<Cart>(
  baseUrl: "${ApiConstants.baseUrl}add_cart_api/index.php",
  model: Cart(id: '', userId: '', coffeeId: '', quantity: 0,size: ''),
);

Future<void> addToCart(
  String firebaseUid,
  String coffeeId,
  int quantity,
  String? size,
) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}add_cart_api/index.php?action=add",
  );
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "firebase_uid": firebaseUid,
      "coffee_id": coffeeId,
      "quantity": quantity,
      "size": size,
    }),
  );
    print("➡️ [AddToCart] Sending request to: $url");
  print("⬅️ [AddToCart] Status code: ${response.statusCode}");
  print("⬅️ [AddToCart] Response body: ${response.body}");
  

  if (response.statusCode != 200) {
    throw Exception("Failed to add to cart: ${response.body}");
  }
  else {
    print("✅ [AddToCart] Successfully added to cart.");
}
}
/// Increment quantity
Future<void> incrementCart(String firebaseUid, String coffeeId) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}add_cart_api/index.php?action=increment",
  );

  debugPrint("🔹 Incrementing cart -> user:$firebaseUid coffee:$coffeeId");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "firebase_uid": firebaseUid,
      "coffee_id": coffeeId,
    }),
  );

  debugPrint("🔹 Server response: ${response.statusCode} ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to increment: ${response.body}");
  }
}

/// Decrement quantity
Future<void> decrementCart(String firebaseUid, String coffeeId) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}add_cart_api/index.php?action=decrement",
  );

  debugPrint("🔹 Decrementing cart -> user:$firebaseUid coffee:$coffeeId");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "firebase_uid": firebaseUid,
      "coffee_id": coffeeId,
    }),
  );

  debugPrint("🔹 Server response: ${response.statusCode} ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to decrement: ${response.body}");
  }
}


/// Remove item from cart
Future<void> removeFromCart(
  String firebaseUid,
  String coffeeId,
) async {
  final url = Uri.parse(
    "${ApiConstants.baseUrl}add_cart_api/index.php?action=remove",
  );

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "firebase_uid": firebaseUid,
      "coffee_id": coffeeId,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to remove from cart: ${response.body}");
  }
}


Future<List<Cart>> getUserCart(String firebaseUid) async {
  try {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}add_cart_api/index.php?action=get"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"firebase_uid": firebaseUid}),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final List<dynamic> list = decoded["data"] ?? [];
        return list.map((item) => Cart.fromJson(item)).toList();
      }
    }

    return [];
  } catch (e) {
    return [];
  }
}
