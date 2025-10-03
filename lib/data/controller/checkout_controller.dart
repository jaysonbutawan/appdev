import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/models/coffee.dart';
import 'package:flutter/material.dart';
import 'package:appdev/data/services/coffee_service.dart';
class CheckoutController extends ChangeNotifier {
  final CoffeeApi _coffeeApi = CoffeeApi(); // 👈 create an instance

  bool isPickup = true;
  double subtotal = 0.0;
  double taxes = 0.0;
  double total = 0.0;

  void togglePickup(bool value) {
    isPickup = value;
    notifyListeners();
  }

  Future<void> confirmOrder({
    required String userId,
    List<Cart>? cartItems,
    Coffee? directCoffee,
  }) async {
    final success = await _coffeeApi.createOrder(  // 👈 call via _coffeeApi
      userId: userId,
      cartItems: cartItems,
      directCoffee: directCoffee,
    );

    if (success) {
      // ✅ Do something (clear cart, show snackbar, etc.)
      print("Order created successfully!");
    } else {
      print("Order failed!");
    }
  }
}
