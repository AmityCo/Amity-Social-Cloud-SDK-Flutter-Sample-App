import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showPositiveSnackbar(
      BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [Text(title), Text(message)],
        ),
      ),
    );
    // Get.snackbar(title, message,
    //     backgroundColor: Colors.white, colorText: Colors.black);
  }
}
