import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart';
import 'package:appdev/presentation/pages/screens/login_screen.dart';
import 'package:appdev/presentation/pages/screens/edit_name_bottom_sheet.dart'; 


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(); 
  bool isLogoutClicked = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
 void _handleNameSave(String newName) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Updating name..."),
          ],
        ),
      );
    },
  );

  final success = await authProvider.updateUserName(newName);

  Navigator.of(context).pop();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(success ? "Success" : "Error"),
        content: Text(
          success
              ? "Name updated successfully!"
              : "Failed to update name. Please try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

  void _showEditNameSheet(String currentDisplayName) {
    _nameController.text = currentDisplayName; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (BuildContext context) {
        return EditNameBottomSheet(
          controller: _nameController,
          onSave: _handleNameSave, 
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final User? currentUser = authProvider.getCurrentUser();
                final String email = currentUser?.email ?? "No email";
        final String displayName = currentUser?.displayName ?? "No Name";
        final String? photoUrl = currentUser?.photoURL;
        
        if (currentUser == null) {
          return const Center(child: Text("Please log in."));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(photoUrl, displayName, email),
                const SizedBox(height: 32),

                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => _showEditNameSheet(displayName),
                  child: _buildInfoField('Name', displayName, canEdit: true),
                ),
                const SizedBox(height: 16),
                
                _buildInfoField('Email', email),
                const SizedBox(height: 32),

                _buildSectionTitle('Account Settings'),
                const SizedBox(height: 16),

                _buildMenuOption('Change Password', Icons.arrow_forward_ios),
                const SizedBox(height: 16),

                _buildLogoutOption(authProvider),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // --- Helper Methods (Unchanged) ---
  
  Widget _buildProfileHeader(String? photoUrl, String? name, String email) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name ?? "No Name",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {bool canEdit = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (canEdit) 
                Icon(Icons.edit, size: 16, color: Colors.grey[600]),
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildMenuOption(String title, IconData trailingIcon) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(trailingIcon, size: 16, color: Colors.grey[600]),
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildLogoutOption(AuthProvider authProvider) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Logout Confirmation"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); 
                    await authProvider.logout();
                    Get.offAll(
                      () => const LoginScreen(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  child: const Text("Logout", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        color: isLogoutClicked ? Colors.orange.withOpacity(0.2) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogoutClicked ? Colors.orange : const Color(0xFFFF7A30),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: isLogoutClicked ? Colors.orange : Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}