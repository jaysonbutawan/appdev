import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:appdev/presentation/state/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:appdev/presentation/pages/screens/login_screen.dart';
import 'package:appdev/presentation/widgets/dialog/app_quick_alert.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLogoutClicked = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final String email = user?.email ?? "No email";
    final String? displayName = user?.displayName;
    final String? photoUrl = user?.photoURL;

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

            if (displayName != null) ...[
              _buildInfoField('Name', displayName),
              const SizedBox(height: 16),
            ],

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
  }

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

  Widget _buildInfoField(String label, String value) {
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
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
        AppQuickAlert.showLogout(
          context: context,
          onConfirm: () async {
            await authProvider.logout();
            Get.offAll(
              () => const LoginScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 500),
            );
          },
          onCancel: () {
            setState(() {
              isLogoutClicked = true; // highlight logout row
            });
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        color: isLogoutClicked
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogoutClicked ? Colors.orange : const Color(0xFFFF7A30)
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
