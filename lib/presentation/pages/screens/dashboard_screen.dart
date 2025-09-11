import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart'
    as appdev_auth;
import 'package:sidebarx/sidebarx.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final SidebarXController _sidebarController =
      SidebarXController(selectedIndex: 0, extended: true);

  // Menu items for the grid
  final List<Map<String, dynamic>> items = [
    {"title": "Profile", "icon": Icons.person},
    {"title": "Settings", "icon": Icons.settings},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<appdev_auth.AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Dashboard"),
      ),
      body: Row(
        children: [
          /// Sidebar
          SidebarX(
            controller: _sidebarController,
            theme: const SidebarXTheme(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              textStyle: TextStyle(color: Colors.black87),
              selectedTextStyle: TextStyle(color: Colors.blue),
              selectedItemDecoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            items: const [
              SidebarXItem(icon: Icons.home, label: 'Home'),
              SidebarXItem(icon: Icons.search, label: 'Search'),
              SidebarXItem(icon: Icons.settings, label: 'Settings'),
            ],
          ),

          /// Main content area
          Expanded(
            child: Padding(
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
                      onTap: () async {
                        if (items[index]['title'] == "Logout") {
                          await authProvider.logout();
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(items[index]['icon'],
                              size: 40, color: Colors.blue),
                          const SizedBox(height: 10),
                          Text(
                            items[index]['title'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
