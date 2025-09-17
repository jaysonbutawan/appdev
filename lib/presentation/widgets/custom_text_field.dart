import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText; // initialize with provided value
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure, // ✅ obscure logic handled here
      validator: widget.validator,
      style: const TextStyle(color: Colors.black), // ✅ text color
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.black), // ✅ label color
        prefixIcon: Icon(widget.icon, color: const Color(0xFF493628)),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF493628),
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure; // toggle password visibility
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF493628), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 212, 150, 56), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF493628), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF493628), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
