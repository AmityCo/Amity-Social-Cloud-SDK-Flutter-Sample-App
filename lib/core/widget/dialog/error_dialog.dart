import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  static Future show(BuildContext context,
      {required String title, required String message}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: ErrorDialog(message: message),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(AppRoute.login);
                },
                child: const Text('Logout'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
