import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> showCustomDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? imagePath, // ✅ path to image asset
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onOk != null) onOk();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  static Future<void> showSuccess(
    BuildContext context,
    String message, {
    VoidCallback? onOk,
  }) {
    return showCustomDialog(
      context,
      title: "Success",
      message: message,
      imagePath: "assets/applogo.png",
      onOk: onOk,
    );
  }

  static Future<void> showError(
    BuildContext context,
    String message, {
    VoidCallback? onOk,
  }) {
    return showCustomDialog(
      context,
      title: "Error",
      message: message,
      imagePath: "assets/error.png",
      onOk: onOk,
    );
  }

  static Future<void> showWarning(
    BuildContext context,
    String message, {
    VoidCallback? onOk,
  }) {
    return showCustomDialog(
      context,
      title: "Warning",
      message: message,
      imagePath: "assets/applogo.png",
      onOk: onOk,
    );
  }
}
