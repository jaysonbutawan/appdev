import 'dart:convert';
import 'package:appdev/core/constants.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<String>> getAllCategories() async {
    final url = Uri.parse("${ApiConstants.baseUrl}categories/index.php?action=get");
    print("[CategoryService] Fetching categories from: $url");

    try {
      final response = await http.get(url);
      print("[CategoryService] Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("[CategoryService] Decoded response: $decoded");

        if (decoded["success"] == true) {
          final List<dynamic> data = decoded["data"];
          final categories = data.map((e) => e["name"].toString()).toList();

          // Add "All" as the first option
          categories.insert(0, "All");
          print("[CategoryService] Categories loaded successfully: $categories");
          return categories;
        } else {
          print("[CategoryService] Server returned success=false");
        }
      } else {
        print("[CategoryService] Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("[CategoryService] Error while fetching categories: $e");
    }

    print("[CategoryService] Returning fallback category list");
    return ["All"];
  }
}
