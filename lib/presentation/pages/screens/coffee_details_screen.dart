import 'package:flutter/material.dart';
import 'package:appdev/core/themes/app_gradient.dart';
import 'package:appdev/data/models/product.dart';
import 'package:appdev/presentation/widgets/product/product_header.dart';
import 'package:appdev/presentation/widgets/product/product_image.dart';
import 'package:appdev/presentation/widgets/product/product_size_selector.dart';
import 'package:appdev/utils/cart_helper.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.mainBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductHeader(coffeeId: product.id,),
                const SizedBox(height: 20),
                ProductImage(imageBytes: product.imageBytes),
                const SizedBox(height: 20),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 241, 87, 5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  "Price: \$${product.price}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      handleAddToCart(context, product.id, product.name);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A30),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                const ProductSizeSelector(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.name} ordered!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A30),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(50, 50),
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
