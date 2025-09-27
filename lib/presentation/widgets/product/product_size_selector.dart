import 'package:flutter/material.dart';

class ProductSizeSelector extends StatelessWidget {
  const ProductSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SizeOption(label: 'Medium', isSelected: true, highlightColor: const Color(0xFFFF7A30)),
            const SizedBox(width: 12),
            _SizeOption(label: 'Small'),
            const SizedBox(width: 12),
            _SizeOption(label: 'Large'),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Medium selected',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color highlightColor;

  const _SizeOption({
    required this.label,
    this.isSelected = false,
    this.highlightColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? highlightColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? highlightColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
