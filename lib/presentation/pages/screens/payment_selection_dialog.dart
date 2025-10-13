import 'package:flutter/material.dart';

// --- 1. The Dialog Content Widget ---
Widget _buildPaymentSelectionDialog(BuildContext context) {
  final List<Map<String, dynamic>> paymentOptions = [
    {"label": "Cash on Pickup", "icon": Icons.attach_money},
    {"label": "GCash", "icon": Icons.account_balance_wallet},
    {"label": "Credit / Debit Card", "icon": Icons.credit_card},
    {"label": "Maya", "icon": Icons.phone_iphone},
  ];

  return DraggableScrollableSheet(
    initialChildSize: 0.45, // Start height (45% of screen)
    minChildSize: 0.3,
    maxChildSize: 0.8,
    expand: false,
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            // --- Grab bar ---
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // --- Title ---
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Select Payment Method",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // --- List of payment methods ---
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: paymentOptions.length,
                itemBuilder: (context, index) {
                  final option = paymentOptions[index];
                  return ListTile(
                    leading: Icon(option["icon"], color: Colors.brown),
                    title: Text(option["label"]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // ✅ Close and return selected method
                      Navigator.pop(context, option["label"]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

// --- 2. The Callable Function ---
Future<String?> showPaymentSelectionDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return _buildPaymentSelectionDialog(context);
    },
  );
}
