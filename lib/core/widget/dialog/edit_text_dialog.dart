import 'package:flutter/material.dart';

class EditTextDialog extends StatelessWidget {
  final String defString;
  final String? hintText;
  final ValueChanged? onChange;
  final ValueChanged? onPress;
  EditTextDialog(
      {Key? key,
      required this.defString,
      this.hintText,
      this.onChange,
      this.onPress})
      : super(key: key) {
    _textEditController.text = defString;
  }

  static Future show(BuildContext context,
      {String? title,
      String? defString,
      String? hintText,
      String? buttonText,
      ValueChanged<String>? onChange,
      ValueChanged<String>? onPress}) {
    return showDialog(
        context: context,
        builder: (context) {
          String? text = defString;
          return AlertDialog(
            title: Text(title ?? 'Edit Text'),
            content: EditTextDialog(
              defString: defString ?? '',
              hintText: hintText ?? '',
              onChange: (value) {
                text = value;
                onChange?.call(text!);
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPress?.call(text ?? '');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(buttonText ?? 'Update'),
              ),
            ],
          );
        });
  }

  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditController,
      onChanged: onChange,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
