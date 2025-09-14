import 'dart:convert';
import 'base_model.dart';
import 'dart:typed_data';

class Coffee extends BaseModel {
  final String id;
  final String title;
  final String description;
  final String imageBase64;
  final String category;
  final String price;

  Coffee({
    required this.id,
    required this.title,
    required this.description,
    required this.imageBase64,
    required this.category,
    required this.price,
  });

  @override
  Coffee fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageBase64: json['image'] ?? '', // Base64 string
      category: json['category'] ?? '',
      price: json['price']?.toString() ?? '0',
    );
  }

  Uint8List get imageBytes => base64Decode(imageBase64);
}
