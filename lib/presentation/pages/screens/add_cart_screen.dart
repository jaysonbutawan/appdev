import 'package:flutter/material.dart';
import 'package:appdev/data/models/cart.dart';
import 'package:appdev/data/services/cart_service.dart';
import 'package:appdev/presentation/pages/cards/cart_product_card.dart';
import 'package:appdev/presentation/widgets/checkout_section.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        backgroundColor: const Color(0xFFFF7A30),
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Proceeding to Checkout...")),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
