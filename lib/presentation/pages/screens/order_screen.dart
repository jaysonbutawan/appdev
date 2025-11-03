import 'package:appdev/presentation/pages/cards/order_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdev/data/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<dynamic>> _ordersFuture;
  String _selectedFilter = 'All';
  String? _user_id;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _user_id = user?.uid;
    _ordersFuture = user != null
        ? OrderService.getUserOrders(user.uid)
        : Future.value([]);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color.fromARGB(255, 48, 30, 4);
      case 'cancelled':
        return const Color.fromARGB(255, 202, 49, 38);
      case 'ready':
      case 'ready for pick up':
        return Colors.green[700]!;
      case 'pending':
      case 'preparing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatItems(dynamic items) {
    if (items == null) return "No items";
    if (items is String) return items.isEmpty ? "No items" : items;
    if (items is List && items.isNotEmpty) {
      return items
          .map(
            (i) =>
                "${i['coffee_name'] ?? i['name'] ?? 'Item'} (${i['size'] ?? '—'}) x${i['quantity'] ?? 1}",
          )
          .join(", ");
    }
    return "No items";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'User Order History',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'My Orders',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          _buildFilterTabs(),
          Expanded(
            child: RefreshIndicator(
              onRefresh:
                  _loadOrders, 
              child: FutureBuilder<List<dynamic>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: GoogleFonts.inter(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No orders found."));
                  }

                  final allOrders = snapshot.data!;
                  final filteredOrders = _selectedFilter == "All"
                      ? allOrders
                      : allOrders.where((order) {
                          final status = order["status"]?.toLowerCase() ?? "";
                          if (_selectedFilter == "Active") {
                            return [
                              "pending",
                              "accepted",
                              "preparing",
                              "ready",
                            ].contains(status);
                          } else if (_selectedFilter == "Past") {
                            return ["completed", "cancelled"].contains(status);
                          }
                          return true;
                        }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final items = order["items"];
                      final status = (order["status"] ?? "").toLowerCase();
                      final isButtonEnabled = status != "completed";

                      return OrderCard(
                        storeName: order["store_name"] ?? "Unknown Store",
                        orderDate: order["created_at"] ?? "",
                        totalAmount: "${order["total_amount"] ?? 0}",
                        items: _formatItems(items),
                        status: order["status"] ?? "Unknown",
                        statusColor: _getStatusColor(
                          order["status"] ?? "Unknown",
                        ),
                        buttonText:
                            (status == "ready" || status == "ready for pick up")
                            ? "Confirm Order"
                            : "Cancel Order",
                        isButtonEnabled: isButtonEnabled,
                        onButtonTap: () {
                          if (status == "ready" ||
                              status == "ready for pick up") {
                            completeOrder(order);
                          } else if (status != "completed") {
                            cancelOrder(order);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ["All", "Active", "Past"];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((filter) {
          final bool isSelected = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 48, 30, 4)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Text(
                    filter,
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void cancelOrder(Map<String, dynamic> order) async {
    final orderId = order['order_id']?.toString() ?? '';

    if (orderId.isEmpty) {
      Flushbar(
        message: "Invalid order ID.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.redAccent,
      ).show(context);
      return;
    }

    final status = order['status']?.toString().toLowerCase() ?? '';
    if (status == 'cancelled' || status == 'completed') {
      Flushbar(
        message: "Order is already $status).",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: const Color(0xFFFF9A00),
      ).show(context);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Order"),
        content: const Text(
          "You want to cancel this order? This action cannot be undone and no refund.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    Flushbar(
      message: "Cancelling order...",
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.blueAccent,
    ).show(context);

    final success = await OrderService.cancelOrder(orderId, _user_id ?? '');

    if (success) {
      Flushbar(
        message: "Order cancelled successfully.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 113, 52, 2),
      ).show(context);
      await _loadOrders();
    } else {
      Flushbar(
        message: "Failed to cancel order.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: const Color(0xFFFF9A00),
      ).show(context);
    }
  }

  void completeOrder(Map<String, dynamic> order) async {
    final orderId = order['order_id']?.toString() ?? '';

    if (orderId.isEmpty) {
      Flushbar(
        message: "Invalid order ID.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.redAccent,
      ).show(context);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: const Text("Do you want to confirm this order as completed?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Confirm"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    Flushbar(
      message: "Updating order status...",
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.blueAccent,
    ).show(context);

    final success = await OrderService.completeOrder(orderId, _user_id ?? '');

    if (success) {
      Flushbar(
        message: "Order confirmed as completed.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 113, 52, 2),
      ).show(context);
      await _loadOrders();
    } else {
      Flushbar(
        message: "Failed to update order.",
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: const Color(0xFFFF9A00),
      ).show(context);
    }
  }

  Future<void> _loadOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _ordersFuture = user != null
          ? OrderService.getUserOrders(user.uid)
          : Future.value([]);
    });
  }
}
