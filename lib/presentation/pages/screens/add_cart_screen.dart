import 'package:flutter/material.dart';
import 'package:appdev/presentation/pages/cards/cart_product_card.dart';
import 'package:appdev/presentation/widgets/checkout_section.dart';

class AddCartScreen extends StatelessWidget {
  const AddCartScreen({super.key});
   
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {"name": "Classic Espresso", "price": 3.50, "imageUrl": "https://images.unsplash.com/photo-1529042410759-befb1204b468", "quantity": 1},
      {"name": "Cappuccino", "price": 4.20, "imageUrl": "https://images.unsplash.com/photo-1511920170033-5b5c5c5c5c5c", "quantity": 1},
      {"name": "Caramel Latte", "price": 4.80, "imageUrl": "https://images.unsplash.com/photo-1511920170033-5b5c5c5c5c5c", "quantity": 1},
    ];

    double totalAmount = products.fold(0, (sum, product) => 
        sum + (product["price"] * product["quantity"]));

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ProductCard(
                    name: product["name"],
                    price: product["price"],
                    imageUrl: product["imageUrl"],
                    quantity: product["quantity"],
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