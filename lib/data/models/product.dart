import 'dart:typed_data';

class Product {
  final String id;
  final String name;
  final Uint8List? imageBytes;
  final String category;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageBytes,
    required this.category,
    required this.price,
    required this.description,
  });
}
