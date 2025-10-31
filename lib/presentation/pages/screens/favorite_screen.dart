import 'package:flutter/material.dart';
import 'package:appdev/data/models/coffee.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appdev/data/services/coffee_service.dart';
import 'package:appdev/presentation/pages/cards/coffee_card.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final CoffeeApi _coffeeApi = CoffeeApi();
  List<Coffee> _favoriteCoffees = [];
  bool _loading = true;
final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _coffeeApi.getFavoriteCoffees(_userId);
      setState(() {
        _favoriteCoffees = favorites;
        _loading = false;
      });
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.white,
        ),
        title: const Text(
          "Your Favorite Coffees",
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: _favoriteCoffees.isEmpty
                  ? const Center(
                      child: Text(
                        "You have no favorite coffees yet ",
                        style: TextStyle(color: Colors.brown, fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
    onRefresh: _loadFavorites,
    color: Colors.white,
    backgroundColor: Colors.white,
    child: GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _favoriteCoffees.length,
      itemBuilder: (context, index) {
        final coffee = _favoriteCoffees[index];

        Uint8List? imageBytes;
        if (coffee.imageBase64.isNotEmpty) {
          try {
            imageBytes = base64Decode(coffee.imageBase64);
          } catch (e) {
            print("Image decode error: $e");
          }
        }

        return CoffeeCard(
          id: coffee.id,
          name: coffee.name,
          imageBytes: imageBytes,
          category: coffee.category,
          price: coffee.price,
          description: coffee.description,
        );
      },
    ),
  ),

            ),
    );
  }
}
