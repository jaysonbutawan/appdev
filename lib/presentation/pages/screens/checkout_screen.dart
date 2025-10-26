import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/models/coffeehouse.dart';
import 'package:appdev/data/services/cart_service.dart';
import 'package:appdev/presentation/pages/screens/order_screen.dart';
import 'package:appdev/data/services/coffeehouse_service.dart';
import 'package:appdev/data/services/order_service.dart';
import 'package:appdev/presentation/pages/screens/payment_input_dialog.dart';

import 'package:appdev/presentation/pages/screens/coffee_house_selection_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? orderItems; // null if from cart
  final bool isFromCart;

  const CheckoutScreen({super.key, this.orderItems, this.isFromCart = true});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  bool _isPickup = true;
  bool _loading = true;
  List<Cart> _cartItems = [];
  CoffeeHouse? _coffeeHouse;

  @override
  void initState() {
    super.initState();
    if (widget.isFromCart) {
      _loadCartData();
      _loadCoffeeHouseInfo();
    } else {
      _loading = false;
        _loadCoffeeHouseInfo();
    }
  }

  Future<void> _loadCoffeeHouseInfo() async {
    try {
      final house = await CoffeeHouseApi().getCoffeeHouseById("1");
      setState(() {
        _coffeeHouse = house;
      });
    } catch (e) {
      debugPrint("❌ Failed to load coffee house: $e");
      setState(() {
        _coffeeHouse = null; // explicitly mark as not found
      });
    }
  }

  // 🧩 Fetch Cart Items from API
  Future<void> _loadCartData() async {
    if (_user == null) return;
    try {
      final items = await getUserCart(_user.uid);
      setState(() {
        _cartItems = items;
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Failed to load cart: $e");
      setState(() => _loading = false);
    }
  }

  // 💰 Calculate Total Price
  double _calculateTotal(List<Cart> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + ((item.coffeePrice ?? 0) * item.quantity),
    );
  }

// 🧾 Confirm Order (clear cart or handle direct order)
Future<void> _confirmOrder(List<Cart> items, double payment) async {
  if (_user == null) return;

  try {
    debugPrint("✅ Confirming order for user: ${_user.uid}");
    debugPrint("🛒 Total Items: ${items.length}");

    // ✅ Save the order in the database
    await OrderService.saveOrder(
      userId: _user.uid,
      coffeeHouse: _coffeeHouse,
      items: items,
      paymentAmount: payment,
      isPickup: _isPickup,
    );

    // ✅ If order came from cart, clear it
    if (widget.isFromCart) {
      for (var cart in items) {
        await removeFromCart(_user.uid, cart.coffeeId);
      }
    }

    debugPrint("🎉 Order successfully saved!");

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderScreen()),
      );
    }
  } catch (e) {
    debugPrint("❌ Order failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order failed: $e")),
    );
  }
}


  // 🧱 Toggle between Pickup & Delivery
  void _togglePickup(bool value) {
    setState(() => _isPickup = value);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.isFromCart
        ? _cartItems
        : (widget.orderItems ?? [])
              .map(
                (i) => Cart(
                  id: '',
                  userId: _user?.uid ?? '',
                  coffeeId: i['coffeeId'] ?? '',
                  coffeeName: i['name'] ?? '',
                  coffeePrice: i['price'] ?? 0.0,
                  quantity: i['quantity'] ?? 1,
                  size: i['size'] ?? '',
                ),
              )
              .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Your Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text("No items in your order"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPickupDeliveryToggle(),
                  const SizedBox(height: 24),
                  if (_coffeeHouse != null)
                    _buildCoffeeHouseInfo(_coffeeHouse!),
                  if (_coffeeHouse == null && !_loading)
                    const SizedBox(height: 24),
                  _buildOrderSummary(items),
                  const SizedBox(height: 24),
                  _buildPriceBreakdown(items),
                  const SizedBox(height: 32),
                  _buildConfirmButton(items),
                ],
              ),
            ),
    );
  }

  // 🔘 PICKUP / DELIVERY Toggle
  Widget _buildPickupDeliveryToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _togglePickup(true),
              child: Container(
                decoration: BoxDecoration(
                  color: _isPickup
                      ? const Color.fromARGB(255, 48, 30, 4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Pick Up',
                    style: TextStyle(
                      color: _isPickup ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _togglePickup(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Delivery',
                    style: TextStyle(
                      color: _isPickup ? Colors.grey[600] : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeHouseInfo(CoffeeHouse? house) {
    if (house == null) {
      // ❌ No coffee house available
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "⚠️ No available coffee house found",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // ✅ Coffee house info
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFF7A30)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            house.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            house.address,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            'Prep Time: ${house.prepTime} mins',
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 4, 181, 69),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                final selectedHouse = await showCoffeeHouseSelectionDialog(
                  context,
                );

                if (selectedHouse != null) {
                  setState(() {
                    _coffeeHouse = selectedHouse;
                  });
                }
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<Cart> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        for (var item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.quantity}x",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.coffeeName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if ((item.size ?? '').isNotEmpty)
                        Text(
                          item.size!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  "₱${(item.coffeePrice ?? 0) * item.quantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // 💵 Price Breakdown
  Widget _buildPriceBreakdown(List<Cart> items) {
    final subtotal = _calculateTotal(items);
    const taxes = 0.20; // fixed example

    final total = subtotal + taxes;

    return Column(
      children: [
        _buildPriceRow("Subtotal", "₱${subtotal.toStringAsFixed(2)}"),
        _buildPriceRow("Taxes & Fees", "₱${taxes.toStringAsFixed(2)}"),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFFF7A30))),
          ),
          child: _buildPriceRow(
            "Total",
            "₱${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
      ],
    );
  }

Widget _buildConfirmButton(List<Cart> items) {
  final totalAmount = _calculateTotal(items);

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        final payment = await showPaymentInputDialog(context, totalAmount);

        if (payment == null) {
          debugPrint("⚠️ Payment cancelled");
          return;
        }

        if (payment < totalAmount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Insufficient payment! You need ₱${(totalAmount - payment).toStringAsFixed(2)} more.",
              ),
            ),
          );
          return;
        }

        // ✅ Proceed with saving order to DB
        debugPrint("✅ Payment accepted: ₱$payment");
        await _confirmOrder(items, payment);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 48, 30, 4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Confirm Pick-Up",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}



}
