import 'package:flutter/material.dart';

class AddCartScreen extends StatelessWidget {
  const AddCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A30),
      ),

      body: const Stack(children: [Padding(padding: EdgeInsets.all(16))]),
    );
  }
}
