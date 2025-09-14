import 'package:flutter/material.dart';
import 'package:appdev/presentation/pages/cards/cart_product_card.dart';

class AddCartScreen extends StatelessWidget {
  const AddCartScreen({super.key});
   

  @override
  Widget build(BuildContext context) {

      final List<Map<String, dynamic>> products = [
      {"name": "Classic Espresso", "price": 3.50, "imageUrl": "", "quantity": 1},
      {"name": "Cappuccino", "price": 4.20, "imageUrl": "", "quantity": 1},
      {"name": "Caramel Latte", "price": 4.80, "imageUrl": "", "quantity": 1},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A30),
      ),

       body: ListView.builder(
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
    );
  }
}
