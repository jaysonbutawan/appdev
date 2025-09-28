import 'dart:convert';
import 'package:appdev/data/models/base_model.dart';
import 'package:http/http.dart' as http;

class ApiService<T extends BaseModel> {
  final String baseUrl;
  final T model;

  ApiService({required this.baseUrl, required this.model});

  Future<List<T>> getAll({
    String action = "all",
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      baseUrl,
    ).replace(queryParameters: {"action": action, ...?queryParams});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return [];
      }

      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final List<dynamic> list = decoded["data"] ?? [];
        return list.map((item) => model.fromJson(item) as T).toList();
      }

      if (decoded is List) {
        return decoded.map((item) => model.fromJson(item) as T).toList();
      }

      return [];
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  Future<T> getById(String id, {String action = "single"}) async {
    final uri = Uri.parse(
      baseUrl,
    ).replace(queryParameters: {"action": action, "id": id});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return model.fromJson(data["data"]) as T;
    } else {
      throw Exception("Failed to load item with id $id");
    }
  }

  Future<List<T>> postAll({
    String action = "",
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {"action": action});

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body ?? {}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final List<dynamic> list = decoded["data"] ?? [];
        return list.map((item) => model.fromJson(item) as T).toList();
      }
      if (decoded is List) {
        return decoded.map((item) => model.fromJson(item) as T).toList();
      }
    }

    throw Exception("Failed to load data: ${response.statusCode}");
  }
}
