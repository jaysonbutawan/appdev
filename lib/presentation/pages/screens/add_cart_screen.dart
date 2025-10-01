import 'package:appdev/presentation/pages/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/services/cart_service.dart';
import 'package:appdev/presentation/pages/cards/cart_product_card.dart';
import 'package:appdev/presentation/widgets/checkout_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/core/themes/app_gradient.dart';

class AddCartScreen extends StatefulWidget {
  const AddCartScreen({super.key});

  @override
  State<AddCartScreen> createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  List<Cart> _cartItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final items = await getUserCart(user.uid);
      setState(() {
        _cartItems = items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = _cartItems.fold(
      0,
      (sum, item) => sum + ((item.coffeePrice ?? 0) * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.mainBackground,
          ),
        ),
        title: const Text(
          "Your Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.mainBackground,
              ),
              child: 
          Column(
              children: [
                if (_cartItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Your cart is empty.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                Expanded(
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
                        ),
                      );
                    },
                  ),
                ),
                CheckoutSection(
                  totalAmount: totalAmount,
                  onCheckout: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                  },
                ),
                const SizedBox(height: 10),
                ],
            ),
          ),
    );
  }
}

