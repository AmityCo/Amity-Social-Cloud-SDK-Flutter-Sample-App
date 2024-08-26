import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class UpdateCustomPostScreen extends StatefulWidget {
  const UpdateCustomPostScreen({Key? key, required this.amityPost})
      : super(key: key);
  final AmityPost amityPost;

  @override
  State<UpdateCustomPostScreen> createState() => _UpdateCustomPostScreenState();
}

class _UpdateCustomPostScreenState extends State<UpdateCustomPostScreen> {
  final _keyTextController = TextEditingController();
  final _valueTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Custom Post'),
        actions: [
          LoadingButton(
            onPressed: () async {
              try {
                FocusManager.instance.primaryFocus?.unfocus();
                final key = _keyTextController.text.trim();
                final value = _valueTextController.text.trim();

                if (key.isEmpty || value.isEmpty) {
                  CommonSnackbar.showNagativeSnackbar(
                      context, 'Error', 'Key and value cannot be empty');
                  return;
                }

                final customData = {key: value};

                await widget.amityPost
                    .edit()
                    .custom(customData)
                    .build()
                    .update();

                CommonSnackbar.showPositiveSnackbar(
                    context, 'Success', 'Custom Post Updated Successfully');
              } catch (error, stackTrace) {
                print(stackTrace.toString());
                CommonSnackbar.showNagativeSnackbar(
                    context, 'Error', error.toString());
              }
            },
            text: 'UPDATE',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Data',
                style: themeData.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _keyTextController,
                decoration: const InputDecoration(
                  hintText: 'Key',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueTextController,
                decoration: const InputDecoration(
                  hintText: 'Value',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Future<void> Function() onPressed;
  final String text;

  const LoadingButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(text),
    );
  }
}

class CommonSnackbar {
  static void showPositiveSnackbar(
      BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Text('$title: $message'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showNagativeSnackbar(
      BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Text('$title: $message'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
