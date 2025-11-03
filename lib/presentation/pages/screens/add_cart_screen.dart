import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appdev/core/themes/app_gradient.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/services/cart_service.dart';
import 'package:appdev/presentation/pages/cards/cart_product_card.dart';
import 'package:appdev/presentation/pages/screens/checkout_screen.dart';
import 'package:appdev/presentation/widgets/checkout_section.dart';
import 'package:appdev/presentation/pages/screens/user_profile_screen.dart';

class AddCartScreen extends StatefulWidget {
  const AddCartScreen({super.key});

  @override
  State<AddCartScreen> createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  List<Cart> _cartItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    if (_user == null) return;

    try {
      final items = await getUserCart(_user.uid);
      setState(() {
        _cartItems = items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  double get _totalAmount {
    return _cartItems.fold(
      0,
      (sum, item) => sum + ((item.coffeePrice ?? 0) * item.quantity),
    );
  }

  Future<void> _incrementCart(Cart cart) async {
    if (_user == null) return;

    await incrementCart(_user.uid, cart.coffeeId);
    setState(() => cart.quantity += 1);
  }

  Future<void> _decrementCart(Cart cart) async {
    if (_user == null || cart.quantity <= 1) return;

    await decrementCart(_user.uid, cart.coffeeId);
    setState(() => cart.quantity -= 1);
  }

  Future<void> _removeCartItem(Cart cart, int index) async {
    if (_user == null) return;

    setState(() => _cartItems.removeAt(index));
    await removeFromCart(_user.uid, cart.coffeeId);
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final cart = _cartItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductCard(
              name: cart.coffeeName ?? "Unknown Coffee",
              price: cart.coffeePrice ?? 0,
              quantity: cart.quantity,
              imageBytes: cart.imageBytes,
              imageUrl: null,
              onIncrement: () => _incrementCart(cart),
              onDecrement: () => _decrementCart(cart),
              onRemove: () => _removeCartItem(cart, index),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: Color.fromARGB(255, 48, 30, 4),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.mainBackground,
              ),
              child: _cartItems.isEmpty
                  ? _buildEmptyCart()
                  : Column(
                      children: [
                        _buildCartList(),
 CheckoutSection(
  totalAmount: _totalAmount,
  onCheckout: () {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? "No Name";

    // Validation: ignore case and spaces
    if (displayName.trim().isEmpty || displayName.trim().toLowerCase() == "no name") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Incomplete Profile"),
            content: const Text(
              "Please provide your full name first before proceeding to checkout.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog

                  // Navigate to profile screen so they can edit name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Stop checkout navigation
    }

    // ✅ Proceed to checkout if name is valid
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );
  },
),


                      ],
                    ),
            ),
    );
  }
}
