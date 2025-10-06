import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/coffeehouse.dart';

class CoffeeHouseApi {
  Future<List<CoffeeHouse>> getAllCoffeeHouses() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}store_api/index.php?action=all"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List data = jsonData["data"];
        return data.map((e) => CoffeeHouse.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch coffee houses. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching coffee houses: $e");
    }
  }

  Future<CoffeeHouse> getCoffeeHouseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}store_api/index.php?action=single&id=$id"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CoffeeHouse.fromJson(jsonData["data"]);
      } else {
        throw Exception("Failed to fetch coffee house. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching coffee house by ID: $e");
    }
  }
}
