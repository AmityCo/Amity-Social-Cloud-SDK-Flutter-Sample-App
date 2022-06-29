import 'package:flutter/material.dart';

class PositiveDialog extends StatelessWidget {
  final String message;
  const PositiveDialog({Key? key, required this.message}) : super(key: key);

  static Future show(BuildContext context,
      {required String title,
      required String message,
      VoidCallback? onPostiveCallback}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: PositiveDialog(message: message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPostiveCallback?.call();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(message);
  }
}
