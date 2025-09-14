import 'package:flutter/material.dart';
import 'package:flutter_advanced_cards/flutter_advanced_cards.dart';
import 'dart:typed_data';

class CoffeeCard extends StatelessWidget {
  final String name;
  final String description;
  final Uint8List? imageBytes;
  final String category;
  final String price;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageBytes,
    required this.category,
    required this.price,
  });

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
      buttons: const [
        CardButton(
          text: 'Add to Cart',
          style: CardButtonStyle.elevated,
          backgroundColor: Color(0xFFFF7A30),
        ),
      ],
    );
  }
}
