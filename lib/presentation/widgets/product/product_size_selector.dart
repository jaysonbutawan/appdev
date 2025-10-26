import 'package:flutter/material.dart';

class ProductSizeSelector extends StatefulWidget {
   final ValueChanged<String>? onSizeSelected; //
  const ProductSizeSelector({super.key, this.onSizeSelected});

  @override
  State<ProductSizeSelector> createState() => _ProductSizeSelectorState();
}

class _ProductSizeSelectorState extends State<ProductSizeSelector> {
  String? _selectedSize;

  final List<String> sizes = ["Small", "Medium", "Large"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: sizes.map((size) {
            final isSelected = _selectedSize == size;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      _selectedSize = size;
                    });
                    widget.onSizeSelected?.call(size); 
                  },
                child: _SizeOption(
                  label: size,
                  isSelected: isSelected,
                  highlightColor: const Color(0xFFFF7A30),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _selectedSize == null
                ? 'No size selected'
                : 'Selected: $_selectedSize',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color highlightColor;

  const _SizeOption({
    required this.label,
    this.isSelected = false,
    this.highlightColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6), 
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? highlightColor.withValues(alpha: 0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? highlightColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? highlightColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
