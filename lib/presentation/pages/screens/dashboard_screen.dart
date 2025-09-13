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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final List<Coffee> coffeeList = [
  Coffee(
    title: "Classic Espresso",
    description: "Strong and bold, perfect for a quick energy boost.",
    imageUrl: "https://images.unsplash.com/photo-1510626176961-4b57d4fbad03",
    category: "Espresso",
    price: "\$3.00",
  ),
  Coffee(
    title: "Cappuccino",
    description: "Rich espresso with steamed milk and foam.",
    imageUrl: "https://images.unsplash.com/photo-1525610553991-2bede1a236e2",
    category: "Milk Coffee",
    price: "\$4.50",
  ),
  Coffee(
    title: "Caramel Latte",
    description: "Smooth latte with a sweet caramel twist.",
    imageUrl: "https://images.unsplash.com/photo-1529042410759-befb1204b468",
    category: "Flavored Coffee",
    price: "\$5.00",
  ),
];

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSidebarVisible = false;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<appdev_auth.AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A30),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 30,
          onPressed: () {
            setState(() {
              _isSidebarVisible = !_isSidebarVisible;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            iconSize: 30,
            onPressed: () => Get.to(() => const AddCartScreen()),
          ),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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

                Expanded(
                  child: ListView.builder(
                    itemCount: coffeeList.length,
                    itemBuilder: (context, index) {
                      final coffee = coffeeList[index];
                      return CoffeeCard(
                        title: coffee.title,
                        description: coffee.description,
                        imageUrl: coffee.imageUrl,
                        category: coffee.category,
                        price: coffee.price,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🎬 Sidebar overlay on top
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
        ],
      ),
    );
  }
}
