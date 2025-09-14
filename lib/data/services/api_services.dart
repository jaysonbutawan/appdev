import 'dart:convert';
import 'package:appdev/data/models/base_model.dart';
import 'package:http/http.dart' as http;

class ApiService<T extends BaseModel> {
  final String baseUrl;
  final T model;

  ApiService({required this.baseUrl, required this.model});

  Future<List<T>> getAll({String action = "all"}) async {
    final response = await http.get(Uri.parse("$baseUrl?action=$action"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["data"] as List)
          .map((item) => model.fromJson(item) as T)
          .toList();
    } else {
      throw Exception("Failed to load data from $baseUrl");
    }
  }

  Future<T> getById(String id, {String action = "single"}) async {
    final response = await http.get(Uri.parse("$baseUrl?action=$action&id=$id"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return model.fromJson(data["data"]) as T;
    } else {
      throw Exception("Failed to load item with id $id");
    }
  }
}
