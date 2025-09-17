import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFC59560))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style:const TextStyle(color: Color(0xFF493628), fontSize: 14)),
        ),
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFC59560))),
      ],
    );
  }
}
