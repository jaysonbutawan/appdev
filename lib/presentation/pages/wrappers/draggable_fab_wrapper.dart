import 'package:flutter/material.dart';
import 'package:appdev/presentation/widgets/expandable_fab.dart';


class DraggableFabWrapper extends StatefulWidget {
  const DraggableFabWrapper({super.key});

  @override
  State<DraggableFabWrapper> createState() => _DraggableFabWrapperState();
}

class _DraggableFabWrapperState extends State<DraggableFabWrapper> {
  Offset? position;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    // Default position in bottom right corner
    position ??= Offset(
      screenSize.width - 80, // Position from right edge
      screenSize.height - 100 - safeAreaBottom, // Position from bottom with safe area adjustment
    );

    return Positioned(
      left: position!.dx,
      top: position!.dy,
      child: Draggable(
        feedback: Material(
          color: Colors.transparent,
          elevation: 8.0,
          borderRadius: BorderRadius.circular(28.0),
          child: const FloatingActionBar(),
        ),
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          setState(() {
            // Ensure it stays within visible bounds
            final newX = details.offset.dx.clamp(20, screenSize.width - 80).toDouble();
            final newY = details.offset.dy.clamp(
              safeAreaTop + 20, 
              screenSize.height - 100 - safeAreaBottom
            ).toDouble();
            position = Offset(newX, newY);
          });
        },
        child: Material(
          elevation: 8.0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28.0),
          child: const FloatingActionBar(),
        ),
      ),
    );
  }
}