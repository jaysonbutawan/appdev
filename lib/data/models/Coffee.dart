import 'dart:convert';
import 'base_model.dart';
import 'dart:typed_data';

class Coffee extends BaseModel {
  final String id;
  final String name;
  final String description;
  final String imageBase64;
  final String category;
  final String price; // ✅ Better to store price as double

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.imageBase64,
    required this.category,
    required this.price,
  });

  @override
  Coffee fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageBase64: json['image'] ?? '', // ✅ comes from API as base64 string
      category: json['category'] ?? '',
      price: json['price']?.toString() ?? '0',
    );
  }

  /// Convert base64 image into Uint8List for Image.memory
  Uint8List? get imageBytes {
    if (imageBase64.isEmpty) return null;
    try {
      return base64Decode(imageBase64);
    } catch (e) {
      print("❌ Error decoding image for Coffee $id: $e");
      return null;
    }
  }
}
