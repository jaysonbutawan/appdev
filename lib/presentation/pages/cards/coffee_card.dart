import 'package:flutter/material.dart';
import 'package:flutter_advanced_cards/flutter_advanced_cards.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdvancedCard(
      fullWidth: true,
      cardImage:
          'https://images.unsplash.com/photo-1487058792275-0ad4aaf24ca7',
      imagePosition: ImagePosition.top,
      imageRatio: ImageRatio.oneThird,
      shadowColor: const Color(0xFFFF7A30),
      showBookmarkIcon: true,
      title: 'Sarah Chen',
      customChips: [
        ContentChip(
          text: 'Pro',
          backgroundColor: Colors.purple[600],
          textColor: Colors.white,
        ),
      ],
      chipPosition: ContentChipPosition.rightOfTitle,
      description: 'Senior UX Designer at Google • 8 years experience',
      iconTextPairs: const [
        IconTextPair(
          icon: Icons.work_outline,
          text: 'Price',
        ),
      ],
      buttons: [
        CardButton(
          text: 'Checkout',
          style: CardButtonStyle.elevated,
          backgroundColor: Colors.purple[600],
        ),
        const CardButton(
          text: 'Add to cart',
          style: CardButtonStyle.outlined,
        ),
      ],
    );
  }
}
