import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final double width;
  final TextEditingController textController;
  final VoidCallback onSuffixTap;
  final bool autoFocus;
  final bool closeOnSuffixTap;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final int animationDurationInMilli;
  final String helpText;
  final ValueChanged<String>? onChanged;

  const AnimatedSearchBar({
    super.key,
    required this.width,
    required this.textController,
    required this.onSuffixTap,
    this.autoFocus = false,
    this.closeOnSuffixTap = false,
    this.prefixIcon = const Icon(Icons.search, color: Color(0xFFFF9A00)),
    this.suffixIcon = const Icon(Icons.clear, color: Color(0xFFFF9A00)),
    this.animationDurationInMilli = 275,
    this.helpText = "Search...",
    this.onChanged,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: widget.animationDurationInMilli),
          width: _isExpanded
              ? MediaQuery.of(context).size.width *
                    0.85// expands responsively
              : 50, // collapsed size
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF9A00), width: 2),
          ),
          child: _isExpanded
              ? Row(
                  children: [
                    IconButton(
                      icon: widget.prefixIcon,
                      onPressed: () {
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.textController,
                        autofocus: widget.autoFocus,
                        style: const TextStyle(color: Color(0xFFFF9A00)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: widget.helpText,
                          hintStyle: const TextStyle(color: Color(0xFFFF9A00)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                        ),
                        onChanged: widget.onChanged,
                      ),
                    ),
                    IconButton(
                      icon: widget.suffixIcon,
                      onPressed: () {
                        if (widget.closeOnSuffixTap) {
                          setState(() {
                            _isExpanded = false;
                          });
                        }
                        widget.onSuffixTap();
                      },
                    ),
                  ],
                )
              : IconButton(
                  icon: widget.prefixIcon,
                  onPressed: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                ),
        ),
      ],
    );
  }
}
