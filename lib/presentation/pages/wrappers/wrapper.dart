import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';

class Wrapper extends StatefulWidget {
	const Wrapper({super.key});
  @override
    State<Wrapper> createState() => _WrapperState();
  }

class _WrapperState extends State<Wrapper> {
	@override
	Widget build(BuildContext context) {
		return StreamBuilder<User?>(
			stream: FirebaseAuth.instance.authStateChanges(),
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Center(child: CircularProgressIndicator());
				}
				if (snapshot.hasData && snapshot.data != null) {
					return const DashboardScreen();
				} else {
					return const LoginScreen();
				}
			},
		);
	}
}
