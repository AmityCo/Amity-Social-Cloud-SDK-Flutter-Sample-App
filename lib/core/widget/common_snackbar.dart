import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showPositiveSnackbar(BuildContext context, String title, String message,
      {Duration duration = const Duration(seconds: 1)}) {
    final _themeData = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: _themeData.textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: _themeData.textTheme.caption!.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: Colors.black,
      ),
    );
    // Get.snackbar(title, message,
    //     backgroundColor: Colors.white, colorText: Colors.black);
  }

  static void showNagativeSnackbar(BuildContext context, String title, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    final _themeData = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: _themeData.textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: _themeData.textTheme.caption!.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: Colors.red,
      ),
    );
  }
}
