class Product {
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  
  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1, 
  });

  double get totalPrice => price * quantity;

  // Convert Product to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  // Factory constructor for fetching from Firebase
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }
}
