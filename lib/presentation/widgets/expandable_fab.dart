import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingActionBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;

  const FloatingActionBar({
    super.key,
    this.backgroundColor = const Color(0xFFFF9A00),
    this.foregroundColor = const Color.fromARGB(255, 113, 52, 2),
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      activeChild: const Icon(
        Icons.close,
        color: Colors.white,
      ),

      backgroundColor: backgroundColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),

      spacing: 12,
      spaceBetweenChildren: 12,
      openCloseDial: ValueNotifier<bool>(false),
      children: [
        // Remind button
        SpeedDialChild(
          child: const Icon(Icons.notifications),
          label: 'Remind',
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          onTap: () => debugPrint("🔔 Remind clicked"),
        ),
        
        // Email button
        SpeedDialChild(
          child: const Icon(Icons.email),
          label: 'Email',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () => debugPrint("📧 Email clicked"),
        ),
        
        // Star button
        SpeedDialChild(
          child: const Icon(Icons.star),
          label: 'Star',
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          onTap: () => debugPrint("⭐ Star clicked"),
        ),
        
        // Add button
        SpeedDialChild(
          child: const Icon(Icons.add),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onTap: () => debugPrint("➕ Add clicked"),
        ),
      ],

   child: FittedBox(
  child: Image.asset(
    'assets/cup.png',
    color: foregroundColor,
  ),
),

    );
  }
}