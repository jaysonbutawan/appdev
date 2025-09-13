import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.onHome,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 160,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(3, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Menu",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildSidebarItem(
              icon: Icons.home,
              title: 'Home',
              onTap: onHome,
            ),
            _buildSidebarItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: onSettings,
            ),
            _buildSidebarItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}
