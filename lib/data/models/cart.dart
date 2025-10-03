import 'dart:convert';
import 'dart:typed_data';
import 'package:appdev/data/models/base_model.dart';

class Cart extends BaseModel {
  final String id;
  final String userId;
  final String coffeeId;
   int quantity;
  final String? size;
  final String? coffeeName;
  final double? coffeePrice;
  final String coffeeImageBase64;

  Cart({
    required this.id,
    required this.userId,
    required this.coffeeId,
    required this.quantity,
    this.size,
    this.coffeeName,
    this.coffeePrice,
    this.coffeeImageBase64 = '',
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      coffeeId: json['coffee_id'].toString(),
      quantity: int.parse(json['quantity'].toString()),
      size: json['size']?.toString(),
      coffeeName: json['name'],
      coffeePrice: double.tryParse(json['price'].toString()),
      coffeeImageBase64: json['image'] ?? '',
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json) {
    return Cart.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "coffee_id": coffeeId,
      "quantity": quantity,
      "size": size,
    };
  }

  Uint8List? get imageBytes {
    if (coffeeImageBase64.isEmpty) return null;
    try {
      return base64Decode(coffeeImageBase64);
    } catch (e) {
      return null;
    }
  }

  get coffeeImage => null;
}
