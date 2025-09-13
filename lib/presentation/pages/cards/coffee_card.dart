import 'package:flutter/material.dart';
import 'package:flutter_advanced_cards/flutter_advanced_cards.dart';

class CoffeeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String price;

  const CoffeeCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedCard(
      fullWidth: true,
      cardImage: imageUrl,
      imagePosition: ImagePosition.top,
      imageRatio: ImageRatio.oneThird,
      showBookmarkIcon: true,
      title: title,
      customChips: [
        ContentChip(
          text: category,
          backgroundColor: Colors.brown[600],
          textColor: Colors.white,
        ),
      ],
      chipPosition: ContentChipPosition.rightOfTitle,
      description: description,
      iconTextPairs: [
        IconTextPair(
          icon: Icons.local_cafe,
          text: price,
        ),
      ],
      buttons: const [
        CardButton(
          text: 'Checkout',
          style: CardButtonStyle.elevated,
          backgroundColor: Color(0xFFFF7A30),
        ),
      ],
    );
  }
}
