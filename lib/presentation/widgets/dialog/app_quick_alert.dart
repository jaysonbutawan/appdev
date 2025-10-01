import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AppQuickAlert {
  /// Show a customizable QuickAlert
  static void show({
    required BuildContext context,
    required QuickAlertType type,
    String? title,
    String? text,
    String confirmBtnText = "OK",
    String cancelBtnText = "Cancel",
    Color confirmBtnColor = Colors.green,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? customAsset,
  }) {
    QuickAlert.show(
      context: context,
      type: type,
      title: title,
      text: text,
      confirmBtnText: confirmBtnText,
      confirmBtnColor: confirmBtnColor,
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        if (onConfirm != null) onConfirm();
      },
      showCancelBtn: onCancel != null,
      cancelBtnText: cancelBtnText,
      onCancelBtnTap: () {
        Navigator.of(context).pop();
        if (onCancel != null) onCancel();
      },
      widget: customAsset,
    );
  }

  /// Logout confirmation alert
  static void showLogout({
    required BuildContext context,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Logout",
      text: "Do you really want to log out?",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      confirmBtnColor: const Color(0xFFFF7A30),
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  /// Prompt for order confirmation
  static void showOrderSuccess({
    required BuildContext context,
    String message = "Your order has been placed!",
  }) {
    show(
      context: context,
      type: QuickAlertType.success,
      title: "Order Success",
      text: message,
      confirmBtnText: "Great",
      confirmBtnColor: const Color(0xFFFF7A30),
      customAsset: Image.asset("assets/error.png", height: 120),
    );
  }

  /// Prompt when coffee added to cart
  static void showAddedToCart({
    required BuildContext context,
    String message = "Coffee added to cart!",
  }) {
    show(
      context: context,
      type: QuickAlertType.info,
      title: "Added to Cart",
      text: message,
      confirmBtnText: "OK",
      confirmBtnColor: const Color(0xFFFF7A30),
      customAsset: Image.asset("assets/error.png", height: 120),
    );
  }
}
