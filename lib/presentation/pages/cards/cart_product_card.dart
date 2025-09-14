import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image section
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Color(0xFFF5EBE0), 
            ),
            child: const Icon(
              Icons.coffee_maker,
              size: 80,
              color: Colors.brown,
            ),
          ),
          
          // Product details section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Price
                Text(
                  '\$${price.toStringAsFixed(2)} each',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrease button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove, color: Colors.brown),
                      ),
                    ),
                    
                    // Quantity display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    
                    // Increase button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
