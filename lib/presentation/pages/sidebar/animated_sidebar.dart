import 'package:flutter/material.dart';
import 'package:appdev/presentation/pages/sidebar/app_side_bar.dart';

class AnimatedSidebar extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;
  final VoidCallback onHome;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const AnimatedSidebar({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.onHome,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  State<AnimatedSidebar> createState() => _AnimatedSidebarState();
}

class _AnimatedSidebarState extends State<AnimatedSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // start off-screen (left)
      end: Offset.zero, // fully visible
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant AnimatedSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.forward(); // show sidebar
    } else {
      _controller.reverse(); // hide sidebar
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay (fade in/out with animation)
        if (widget.isVisible)
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        // Sidebar sliding in
        SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            width: 250,
            child: AppSidebar(
              onHome: () {
                widget.onHome();
                widget.onClose();
              },
              onSettings: () {
                widget.onSettings();
                widget.onClose();
              },
              onLogout: () async {
                widget.onLogout();
                widget.onClose();
              },
            ),
          ),
        ),
      ],
    );
  }
}
