import 'package:appdev/data/models/base_model.dart';

class Cart extends BaseModel {
  final String id;          // cart id in DB
  final String userId;      // firebase_uid
  final String coffeeId;    // reference to coffee
  final int quantity;

  Cart({
    required this.id,
    required this.userId,
    required this.coffeeId,
    required this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      coffeeId: json['coffee_id'].toString(),
      quantity: int.parse(json['quantity'].toString()),
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
    };
  }
}
