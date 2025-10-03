import 'package:appdev/data/services/api_services.dart';
import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/coffee.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appdev/data/models/cart.dart';

class CoffeeApi {
  final ApiService<Coffee> _api = ApiService<Coffee>(
    baseUrl: "${ApiConstants.baseUrl}coffee_api/index.php",
    model: Coffee(
      id: '',
      name: '',
      description: '',
      imageBase64: '',
      category: '',
      price: '',
    ),
  );

  Future<List<Coffee>> getAllCoffees() async {
    return await _api.getAll();
  }

  Future<Coffee> getCoffeeById(String id) async {
    return await _api.getById(id);
  }

  Future<bool> addFavouriteCoffee(String coffeeId, String userId) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}coffee_api/index.php?action=toggleFavorite",
      ),
      body: {"firebase_uid": userId, "coffee_id": coffeeId},
    );

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    }
    return false;
  }

  Future<bool> checkIfFavorite(String coffeeId, String userId) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConstants.baseUrl}coffee_api/index.php?action=isFavorite",
      ),
      body: {"firebase_uid": userId, "coffee_id": coffeeId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["isFavorite"] == true;
    }
    return false;
  }

  Future<List<Coffee>> searchCoffees(String query) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}coffee_api/index.php?action=search&q=$query",
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List coffees = jsonData["data"];
      return coffees.map((e) => Coffee.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search coffees");
    }
  }

  Future<bool> createOrder({
    required String userId,
    List<Cart>? cartItems, // case: checkout
    Coffee? directCoffee, // case: buy now
    int directQuantity = 1,
    String size = "medium",
  }) async {
    try {
      // 🔹 Build items depending on flow
      final List<Map<String, dynamic>> items = [];

      if (cartItems != null && cartItems.isNotEmpty) {
        // 🛒 From Cart checkout
        items.addAll(
          cartItems.map(
            (cart) => {
              "coffee_id": cart.coffeeId,
              "quantity": cart.quantity,
              "size": size,
              "price": cart.coffeePrice?.toString() ?? "0.00",
            },
          ),
        );
      } else if (directCoffee != null) {
        // ⚡ Direct "Buy Now"
        items.add({
          "coffee_id": directCoffee.id,
          "quantity": directQuantity,
          "size": size,
          "price": directCoffee.price, // from Coffee model
        });
      } else {
        throw Exception("No items provided for order");
      }

      // 🔹 Prepare request body
      final body = {"user_id": userId, "items": items};

      final response = await http.post(
        Uri.parse(
          "${ApiConstants.baseUrl}coffee_api/index.php?action=createOrder",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Order API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      }
      return false;
    } catch (e) {
      print("createOrder error: $e");
      return false;
    }
  }
}
