import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart'
    as appdev_auth;
import 'package:appdev/presentation/pages/sidebar/app_side_bar.dart';
import 'package:appdev/presentation/pages/sidebar/animated_sidebar.dart';

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
          Center(
            child: Text(
              "Welcome, ${user.email}",
              style: const TextStyle(fontSize: 18),
            ),
          ),

          // Sidebar + overlay
          if (_isSidebarVisible) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSidebarVisible = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            AppSidebar(
              onHome: () {
                setState(() => _isSidebarVisible = false);
                // Navigate to home
                Navigator.of(context).pushReplacementNamed('/home');
              },
              onSettings: () {
                setState(() => _isSidebarVisible = false);
                // Navigate to settings
                Navigator.of(context).pushReplacementNamed('/settings');
              },
              onLogout: () async {
                setState(() => _isSidebarVisible = false);
                await authProvider.logout();
                if (!mounted) return;
              },
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
        ],
      ),
    );
  }
}
