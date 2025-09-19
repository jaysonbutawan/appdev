import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart'
    as appdev_auth;
import 'package:appdev/presentation/pages/sidebar/animated_sidebar.dart';
import 'package:appdev/presentation/pages/cards/coffee_card.dart';
import 'package:appdev/data/models/coffee.dart';
import 'package:appdev/presentation/widgets/search_bar.dart';
import 'package:get/get.dart';
import 'add_cart_screen.dart';
import 'package:appdev/data/services/coffee_service.dart';
import 'package:appdev/core/themes/app_gradient.dart';
import 'package:appdev/presentation/pages/wrappers/draggable_fab_wrapper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSidebarVisible = false;
  final TextEditingController textController = TextEditingController();

  late Future<List<Coffee>> _coffeeFuture;

  @override
  void initState() {
    super.initState();
    _coffeeFuture = coffeeApi.getAll();

    _coffeeFuture.then((coffees) {
      for (var coffee in coffees) {
        print("Loaded Coffee -> "
            "ID: ${coffee.id}, "
            "Name: ${coffee.name}, "
            "imageBase64: ${coffee.imageBase64.substring(0, 20)}..., "
            "Description: ${coffee.description}, "
            "Category: ${coffee.category}, "
            "Price: ${coffee.price}");
      }
    }).catchError((err) {
      print("❌ Error loading coffees: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<appdev_auth.AuthProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Color(0xFFFF9A00)),
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            _isSidebarVisible = !_isSidebarVisible;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart,
                            color: Color(0xFFFF9A00)),
                        iconSize: 30,
                        onPressed: () => Get.to(() => const AddCartScreen()),
                      ),
                    ],
                  ),
                ),
              ),

              /// Main content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
                child: Column(
                  children: [
                    AnimatedSearchBar(
                      width: 350,
                      textController: textController,
                      onSuffixTap: () {
                        setState(() {
                          textController.clear();
                        });
                      },
                      onChanged: (value) {
                        print("Searching for: $value");
                      },
                    ),
                    const SizedBox(height: 16),

                    /// ✅ FIXED FutureBuilder closing
                    Expanded(
                      child: FutureBuilder<List<Coffee>>(
                        future: _coffeeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No coffees found"));
                          }

                          final coffees = snapshot.data!;
                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // ✅ two columns
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio:
                                  0.75, // ✅ controls height/width ratio
                            ),
                            itemCount: coffees.length,
                            itemBuilder: (context, index) {
                              final coffee = coffees[index];
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

              

              /// Sidebar
              AnimatedSidebar(
                isVisible: _isSidebarVisible,
                onClose: () {
                  setState(() => _isSidebarVisible = false);
                },
                onHome: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                onSettings: () {
                  Navigator.of(context).pushReplacementNamed('/settings');
                },
                onLogout: () async {
                  await authProvider.logout();
                  if (!mounted) return;
                },
              ),
              const DraggableFabWrapper(),
            
            ],
          ),
        ),
      ),
    );
  }
}
