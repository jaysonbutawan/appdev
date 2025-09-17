import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient mainBackground = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 18, 10), // start color
      Color.fromARGB(255, 65, 35, 25),
      Color(0xFF8D6E63) // end color
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
