import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Uint8List? imageBytes;

  const ProductImage({super.key, this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: imageBytes != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(imageBytes!, fit: BoxFit.cover),
            )
          : const Icon(
              Icons.coffee,
              size: 100,
              color: Color(0xFFD9D9D9),
            ),
    );
  }
}
