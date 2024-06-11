import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class CreateCustomPostScreen extends StatefulWidget {
  const CreateCustomPostScreen({Key? key, this.userId}) : super(key: key);
  final String? userId;

  @override
  State<CreateCustomPostScreen> createState() => _CreateCustomPostScreenState();
}

class _CreateCustomPostScreenState extends State<CreateCustomPostScreen> {
  final _targetUserTextEditController = TextEditingController();
  final _keyTextController = TextEditingController();
  final _valueTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (widget.userId != null) {
      _targetUserTextEditController.text = widget.userId!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Post'),
        actions: [
          LoadingButton(
            onPressed: () async {
              try {
                FocusManager.instance.primaryFocus?.unfocus();
                final target = _targetUserTextEditController.text.trim();
                final key = _keyTextController.text.trim();
                final value = _valueTextController.text.trim();

                if (key.isEmpty || value.isEmpty) {
                  CommonSnackbar.showNagativeSnackbar(
                      context, 'Error', 'Key and value cannot be empty');
                  return;
                }

                final customData = {key: value};

                final amityPost = await AmitySocialClient.newPostRepository()
                    .createPost()
                    .targetUser(target)
                    .custom('amity.custom', customData)
                    .post();

                CommonSnackbar.showPositiveSnackbar(
                    context, 'Success', 'Custom Post Created Successfully');
              } catch (error, stackTrace) {
                print(stackTrace.toString());
                CommonSnackbar.showNagativeSnackbar(
                    context, 'Error', error.toString());
              }
            },
            text: 'POST',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _targetUserTextEditController,
                decoration: InputDecoration(
                  label: Text('Target User'),
                ),
              ),
              const SizedBox(height: 12),
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
