import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart'
    as appdev_auth;
import 'package:appdev/presentation/pages/sidebar/animated_sidebar.dart';
import 'package:appdev/presentation/pages/cards/coffee_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSidebarVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<appdev_auth.AuthProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A30),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isSidebarVisible = !_isSidebarVisible;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: const [
                CoffeeCard(), // 👈 call your custom card
              ],
        ),
          ),
          
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
