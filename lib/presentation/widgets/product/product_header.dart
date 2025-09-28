import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/services/coffee_service.dart';

class ProductHeader extends StatefulWidget {
  final String coffeeId;

  const ProductHeader({
    super.key,
    required this.coffeeId,
  });

  @override
  State<ProductHeader> createState() => _ProductHeaderState();
}

class _ProductHeaderState extends State<ProductHeader> {
  bool isFavorite = false;
  final coffeeApi = CoffeeApi();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fav = await coffeeApi.checkIfFavorite(widget.coffeeId, user.uid);
    setState(() {
      isFavorite = fav;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final success = await coffeeApi.addFavouriteCoffee(widget.coffeeId, user.uid);

    if (success) {
      setState(() => isFavorite = !isFavorite);
      _showMessage(isFavorite ? "Added to favorites ❤️" : "Removed from favorites ❌");
    } else {
      _showMessage("Something went wrong, please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF9A00)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: toggleFavorite,
        ),
      ],
    );
  }
}
