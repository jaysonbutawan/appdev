import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:appdev/presentation/pages/screens/favorite_screen.dart';
import 'package:appdev/presentation/pages/screens/order_screen.dart';

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
      activeChild: const Icon(Icons.close, color: Colors.white),

      backgroundColor: backgroundColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),

      spacing: 12,
      spaceBetweenChildren: 12,
      openCloseDial: ValueNotifier<bool>(false),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.email),
          label: 'Order',
          backgroundColor: const Color.fromARGB(255, 160, 68, 14),
          foregroundColor: Colors.white,
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderScreen()),
            );
          },
        ),

        SpeedDialChild(
          child: const Icon(Icons.favorite),
          label: 'Favorite',
          backgroundColor: const Color.fromARGB(255, 142, 94, 60),
          foregroundColor: Colors.white,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyWidget()),
            );
          },
        ),

        SpeedDialChild(
          child: const Icon(Icons.notifications),
          label: 'Notify',
          backgroundColor: const Color.fromARGB(255, 24, 113, 8),
          foregroundColor: Colors.white,
          onTap: () => debugPrint("➕ Add clicked"),
        ),
      ],

      child: FittedBox(
        child: Image.asset('assets/cup.png', color: foregroundColor),
      ),
    );
  }
}
