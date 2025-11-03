import 'package:another_flushbar/flushbar.dart';
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

  Future<void> toggleFavorite() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    bool currentlyFavorite = await coffeeApi.checkIfFavorite(widget.coffeeId, user.uid);
    final success = await coffeeApi.addFavouriteCoffee(widget.coffeeId, user.uid);
    if (success) {
      setState(() => isFavorite = !currentlyFavorite);
      showFlushbar(
        isFavorite ? "Added to your favorites." : "Removed from your favorites.",
      );
    }
  } catch (e) {
    print("Error toggling favorite: $e");
  }
}

void showFlushbar(String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: const Color.fromARGB(200, 76, 44, 6),
    icon: const Icon(Icons.favorite, color: Colors.white),
  ).show(context);
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
