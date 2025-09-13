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
    this.prefixIcon = const Icon(Icons.search, color: Colors.grey),
    this.suffixIcon = const Icon(Icons.clear, color: Colors.grey),
    this.animationDurationInMilli = 375,
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
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: widget.animationDurationInMilli),
          width: _isExpanded ? widget.width : 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: widget.prefixIcon,
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              if (_isExpanded)
                Expanded(
                  child: TextField(
                    controller: widget.textController,
                    autofocus: widget.autoFocus,
                    decoration: InputDecoration(
                      hintText: widget.helpText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
              if (_isExpanded)
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
          ),
        ),
      ],
    );
  }
}
