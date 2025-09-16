import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This service talks to your backend PHP for add_cart_products
final cartApi = ApiService<Cart>(
  baseUrl: "${ApiConstants.baseUrl}add_cart_api/index.php", 
  model: Cart(
    id: '',
    userId: '',
    coffeeId: '',
    quantity: 0,
  ),
);

Future<void> addToCart(String userId, String coffeeId, int quantity) async {
  final url = Uri.parse("${ApiConstants.baseUrl}add_cart_api/index.php?action=add");

  print("🛒 [DEBUG] Sending addToCart request...");
  print("➡️ firebase_uid: $userId, coffeeId: $coffeeId, quantity: $quantity");

  final response = await http.post(
    url,
    body: {
      "firebase_uid": userId, // ✅ match backend param
      "coffee_id": coffeeId,
      "quantity": quantity.toString(),
    },
  );

  print("📥 [DEBUG] Response status: ${response.statusCode}");
  print("📥 [DEBUG] Raw response body: ${response.body}");

  if (response.statusCode != 200) {
    throw Exception("Failed to add to cart: ${response.body}");
  }

  final data = jsonDecode(response.body);
  print("📦 [DEBUG] Parsed response: $data"); // 👈 place it here

  if (data["status"] != "success") {
    throw Exception("Error from server: ${data["message"]}");
  }

  print("✅ [DEBUG] Product successfully added to cart");
}


// Function to get all cart items of a user
Future<List<Cart>> getUserCart(String userId) async {
  return cartApi.getAll(action: "list&user_id=$userId");
}
