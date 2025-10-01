import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appdev/presentation/pages/cards/coffee_card.dart';
import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/presentation/widgets/search_bar.dart';
import 'package:get/get.dart';
import 'add_cart_screen.dart';
import 'package:appdev/data/services/coffee_service.dart';
import 'package:appdev/core/themes/app_gradient.dart';
import 'package:appdev/presentation/pages/wrappers/draggable_fab_wrapper.dart';
import 'user_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController textController = TextEditingController();

  late Future<List<Coffee>> _coffeeFuture;
  List<Coffee> _allCoffees = [];
  List<Coffee> _filteredCoffees = [];

  @override
  void initState() {
    super.initState();
    _coffeeFuture = CoffeeApi().getAllCoffees();

    _coffeeFuture.then((coffees) {
      setState(() {
        _allCoffees = coffees;
        _filteredCoffees = coffees; // show all initially
      });
    }).catchError((err) {
      print("❌ Error loading coffees: $err");
    });
  }

  void _filterCoffees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCoffees = _allCoffees;
      } else {
        _filteredCoffees = _allCoffees
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.mainBackground),
        child: SafeArea(
          child: Stack(
            children: [
              // 🔹 Top Bar (Profile + Cart)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Avatar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : const AssetImage(
                                      "assets/images/default_avatar.png",
                                    )
                                  as ImageProvider,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Color(0xFFFF9A00),
                        ),
                        iconSize: 36,
                        onPressed: () => Get.to(() => const AddCartScreen()),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 Main Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                child: Column(
                  children: [
                    // Search Bar
                    AnimatedSearchBar(
                      width: 350,
                      textController: textController,
                      onSuffixTap: () {
                        setState(() {
                          textController.clear();
                          _filteredCoffees = _allCoffees; // reset
                        });
                      },
                      onChanged: _filterCoffees,
                    ),
                    const SizedBox(height: 16),

                    // Coffees Grid
                    Expanded(
                      child: FutureBuilder<List<Coffee>>(
                        future: _coffeeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (_filteredCoffees.isEmpty) {
                            return const Center(
                              child: Text("No coffees found"),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _filteredCoffees.length,
                            itemBuilder: (context, index) {
                              final coffee = _filteredCoffees[index];
                              return CoffeeCard(
                                description: coffee.description,
                                id: coffee.id,
                                name: coffee.name,
                                imageBytes: coffee.imageBytes,
                                category: coffee.category,
                                price: coffee.price,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Button
              const DraggableFabWrapper(),
            ],
          ),
        ),
      ),
    );
  }
}
