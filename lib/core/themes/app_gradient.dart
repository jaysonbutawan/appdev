import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient mainBackground = LinearGradient(
    colors: [
      Color.fromARGB(255, 142, 94, 60), // start color
      Color.fromARGB(255, 118, 63, 45),
      Color.fromARGB(255, 130, 87, 71) // end color
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
