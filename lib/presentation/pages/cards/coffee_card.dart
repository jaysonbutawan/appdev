import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/services/cart_service.dart';
import 'package:appdev/presentation/pages/screens/coffee_details_screen.dart';
class CoffeeCard extends StatelessWidget {
  final String id;
  final String name;
  final Uint8List? imageBytes;
  final String category;
  final String price;
  final String description;

  const CoffeeCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageBytes,
    required this.category,
    required this.price,
    required this.description,
  });

  Future<void> _handleAddToCart(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("You must be logged in")));
        return;
      }

      await addToCart(user.uid, id, 1);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$name added to cart")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add to cart: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// ✅ Navigate to ProductDetailScreen and pass data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              id: id,
              name: name,
              imageBytes: imageBytes,
              category: category,
              price: price,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 48, 30, 4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image container
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: Colors.white,
              ),
              child: imageBytes != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.memory(imageBytes!, fit: BoxFit.cover),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.white,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "\$$price",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => _handleAddToCart(context),
                          icon: const Icon(Icons.add_shopping_cart),
                          color: const Color(0xFFFF9A00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
