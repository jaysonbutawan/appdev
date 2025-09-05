import 'package:firebase_auth/firebase_auth.dart'hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart'as appdev_auth;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final authProvider = appdev_auth.AuthProvider();
  signout() async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"title": "Profile", "icon": Icons.person},
      {"title": "Messages", "icon": Icons.message},
      {"title": "Settings", "icon": Icons.settings},
      {"title": "Logout", "icon": Icons.logout},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  if (items[index]['title'] == "Logout") {
                    context.read<appdev_auth.AuthProvider>().logout();
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[index]['icon'], size: 40, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(items[index]['title'],
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}