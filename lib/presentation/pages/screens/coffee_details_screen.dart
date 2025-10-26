import 'package:flutter/material.dart';
import 'package:appdev/core/themes/app_gradient.dart';
import 'package:appdev/data/models/product.dart';
import 'package:appdev/presentation/widgets/product/product_header.dart';
import 'package:appdev/presentation/widgets/product/product_image.dart';
import 'package:appdev/presentation/widgets/product/product_size_selector.dart';
import 'package:appdev/utils/cart_helper.dart';
import 'package:appdev/presentation/pages/screens/checkout_screen.dart'; // 👈 import checkout

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize; // 🧩 store selected size

  void _onSizeSelected(String size) {
    setState(() {
      _selectedSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
                ProductHeader(coffeeId: product.id),
                const SizedBox(height: 20),
                ProductImage(imageBytes: product.imageBytes),
                const SizedBox(height: 20),
                _buildProductInfo(product),
                const SizedBox(height: 20),
                _buildPriceSection(product),
                const SizedBox(height: 20),
                _buildAddToCartButton(context, product),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                ProductSizeSelector(onSizeSelected: _onSizeSelected), 
                const SizedBox(height: 20),
                _buildOrderNowButton(context, product),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, Product product) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedSize == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a size first.")),
            );
            return;
          }

          handleAddToCart(context, product.id, product.name, size: _selectedSize);
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
    );
  }

  Widget _buildOrderNowButton(BuildContext context, Product product) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_selectedSize == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a size first.")),
            );
            return;
          }

          final orderItem = {
            "coffeeId": product.id,
            "name": product.name,
            "price": double.tryParse(product.price) ?? 0.0,
            "quantity": 1,
            "size": _selectedSize,
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                orderItems: [orderItem],
                isFromCart: false,
              ),
            ),
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
    );
  }
}
