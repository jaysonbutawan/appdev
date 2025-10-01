import 'package:appdev/data/services/api_services.dart';
import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/coffee.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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
    Uri.parse("${ApiConstants.baseUrl}coffee_api/index.php?action=search&q=$query"),
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List coffees = jsonData["data"];
    return coffees.map((e) => Coffee.fromJson(e)).toList();
  } else {
    throw Exception("Failed to search coffees");
  }
}
}