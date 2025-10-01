import 'package:flutter/material.dart';
import 'package:appdev/core/themes/app_gradient.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.mainBackground,
          ),
        ),
        title: const Text(
          "Your favorite is me?",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.mainBackground,
              ),
              child: const Center(
          child: Text(
            'Cart content goes here',
            style: TextStyle(color: Colors.white),
          ),
        ),
          )
    );
  }
}