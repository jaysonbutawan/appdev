import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:appdev/core/constants.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/models/coffeehouse.dart';

class OrderService {
  /// ✅ Save order and its items to the database
  static Future<void> saveOrder({
    required String userId,
    required CoffeeHouse? coffeeHouse,
    required List<Cart> items,
    required double paymentAmount,
    required bool isPickup,
  }) async {
    final totalAmount = _calculateTotal(items);

    final url = Uri.parse("${ApiConstants.baseUrl}order/index.php?action=create");
    debugPrint("🛰️ Sending request to: ${url.toString()}");


    final orderPayload = {
      "user_id": userId,
      "store_id": coffeeHouse?.id ?? "",
      "order_type": isPickup ? "pickup" : "delivery",
      "total_amount": totalAmount,
      "payment_amount": paymentAmount,
      "payment_method": "Cash",
      "items": items
          .map((item) => {
                "coffee_id": item.coffeeId,
                "size": item.size ?? "medium",
                "quantity": item.quantity,
                "price": item.coffeePrice,
              })
          .toList(),
    };

    debugPrint("📤 [OrderService] Sending order: ${jsonEncode(orderPayload)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderPayload),
      );

      debugPrint("📦 [OrderService] Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          debugPrint("✅ [OrderService] Order successfully saved. ID: ${data['order_id']}");
        } else {
          throw Exception("⚠️ Server Error: ${data['message']}");
        }
      } else {
        throw Exception("❌ Failed to save order. HTTP ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🔥 [OrderService] Exception while saving order: $e");
      rethrow;
    }
  }

  /// ✅ Get all orders for a user
  static Future<List<dynamic>> getUserOrders(String userId) async {
    final url = Uri.parse("${ApiConstants.baseUrl}order/index.php?action=get");

    debugPrint("📤 [OrderService] Fetching orders for user: $userId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      debugPrint("📦 [OrderService] Orders Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          return data["data"] ?? [];
        } else {
          throw Exception("⚠️ Failed: ${data['message']}");
        }
      } else {
        throw Exception("❌ Failed to fetch orders. HTTP ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🔥 [OrderService] Error fetching orders: $e");
      return [];
    }
  }
 static Future<bool> cancelOrder(String orderId, String userId) async {
  final url = Uri.parse("${ApiConstants.baseUrl}order/index.php?action=cancel");

  debugPrint("📤 [OrderService] Cancelling order ID: $orderId");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": orderId,
        "user_id": userId, // ✅ Add this
      }),
    );

    debugPrint("📦 [OrderService] Cancel Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } else {
      throw Exception("❌ Failed to cancel order. HTTP ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("🔥 [OrderService] Exception while cancelling order: $e");
    return false;
  }
}

static Future<bool> completeOrder(String orderId, String userId) async {
  final url = Uri.parse("${ApiConstants.baseUrl}order/index.php?action=complete");

  debugPrint("📤 [OrderService] Completing order ID: $orderId");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": orderId,
        "user_id": userId, // ✅ Add this
      }),
    );

    debugPrint("📦 [OrderService] Complete Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } else {
      throw Exception("❌ Failed to complete order. HTTP ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("🔥 [OrderService] Exception while completing order: $e");
    return false;
  }
}


  /// ✅ Calculate total price
  static double _calculateTotal(List<Cart> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + ((item.coffeePrice ?? 0) * item.quantity),
    );
  }
}
