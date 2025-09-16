import 'package:flutter/material.dart';
import 'package:flutter_advanced_cards/flutter_advanced_cards.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/services/cart_service.dart';


class CoffeeCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final Uint8List? imageBytes;
  final String category;
  final String price;

  const CoffeeCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.imageBytes,
    required this.category,
    required this.price,
  });
  Future<void> _handleAddToCart(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in")),
        );
        return;
      }

      // Call our addToCart function
      await addToCart(user.uid, id, 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$name added to cart")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedCard(
      fullWidth: true,
      cardImage: imageBytes != null
          ? Image.memory(imageBytes!, fit: BoxFit.cover)
          : const Icon(
              Icons.image_not_supported,
              size: 100,
              color: Colors.grey,
            ),
      imagePosition: ImagePosition.top,
      imageRatio: ImageRatio.oneThird,
      showBookmarkIcon: true,
      title: name,
      customChips: [
        ContentChip(
          text: category,
          backgroundColor: Colors.brown[600],
          textColor: Colors.white,
        ),
      ],
      chipPosition: ContentChipPosition.rightOfTitle,
      description: description,
      iconTextPairs: [IconTextPair(icon: Icons.local_cafe, text: price)],
      buttons:  [
        CardButton(
          text: 'Add to Cart',
          style: CardButtonStyle.elevated,
          backgroundColor:const Color(0xFFFF7A30),
          onPressed:() => _handleAddToCart(context),
        ),
      ],
    );
  }
}
