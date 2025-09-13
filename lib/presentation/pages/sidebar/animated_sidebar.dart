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
      begin: const Offset(-1.0, 0.0), // off-screen left
      end: Offset.zero, // visible
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant AnimatedSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
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
        // ✅ Overlay that closes sidebar when tapping main content
        if (widget.isVisible)
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        // ✅ Sidebar sliding in/out
        SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            width: 200,
            child: AppSidebar(
              onHome: widget.onHome,
              onSettings: widget.onSettings,
              onLogout: widget.onLogout,
            ),
          ),
        ),
      ],
    );
  }
}
