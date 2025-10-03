import 'package:flutter/material.dart';

class CheckoutSection extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onCheckout;

  const CheckoutSection({
    super.key,
    required this.totalAmount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white
        ,
        border: Border(
          top: BorderSide(color: const Color(0xFFFF7A30)),
          bottom: BorderSide(color: const Color(0xFFFF7A30)),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Total Amount",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color:const Color.fromARGB(255, 48, 30, 4),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            "\$${totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF7A30),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7A30),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Check Out",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
