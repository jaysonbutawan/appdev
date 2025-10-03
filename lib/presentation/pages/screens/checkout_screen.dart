import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdev/data/controller/checkout_controller.dart';
import 'package:appdev/presentation/pages/screens/order_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckoutController(),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CheckoutController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Order',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPickupDeliveryToggle(controller),
            const SizedBox(height: 24),
            _buildCoffeeHouseInfo(),
            const SizedBox(height: 24),
            _buildReadyTime(),
            const SizedBox(height: 24),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildAddItemsButton(),
            const SizedBox(height: 24),
            _buildPriceBreakdown(controller),
            const SizedBox(height: 32),
            _buildConfirmButton(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupDeliveryToggle(CheckoutController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.togglePickup(true),
              child: Container(
                decoration: BoxDecoration(
                  color: controller.isPickup ? const Color.fromARGB(255, 48, 30, 4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Pick Up',
                    style: TextStyle(
                      color: controller.isPickup ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.togglePickup(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Delivery',
                    style: TextStyle(
                      color: controller.isPickup ? Colors.grey[600] : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeHouseInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color:  const Color(0xFFFF7A30)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('The Coffee House',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          Text('123 Main St, Anytown USA',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Change',
                style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyTime() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color:  const Color(0xFFFF7A30)),
          bottom: BorderSide(color:  const Color(0xFFFF7A30)),
        ),
      ),
      child: const Center(
        child: Text(
          'Ready in 15-20 mins',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        _buildOrderItem("1x", "Iced Latte", "Oat Milk, 2 shots espresso", "\$4.50"),
        const SizedBox(height: 16),
        _buildOrderItem("1x", "Almond Croissant", "", "\$3.75"),
      ],
    );
  }

  Widget _buildOrderItem(String qty, String name, String desc, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(qty, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (desc.isNotEmpty)
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
        Text(price,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildAddItemsButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color:  const Color(0xFFFF7A30)),
          bottom: BorderSide(color: const Color(0xFFFF7A30)),
        ),
      ),
      child: const Center(
        child: Text("Add Items",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
      ),
    );
  }

  Widget _buildPriceBreakdown(CheckoutController controller) {
    return Column(
      children: [
        _buildPriceRow("Subtotal", "\$${controller.subtotal}"),
        _buildPriceRow("Taxes & Fees", "\$${controller.taxes}"),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color:  const Color(0xFFFF7A30))),
          ),
          child: _buildPriceRow("Total", "\$${controller.total}", isTotal: true),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 16)),
        Text(price,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 16)),
      ],
    );
  }

Widget _buildConfirmButton(BuildContext context, CheckoutController controller) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        await controller.confirmOrder(
          userId: "123",
          cartItems: [],
      
        );
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:const Color.fromARGB(255, 48, 30, 4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        "Confirm Pick-Up",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}

}
