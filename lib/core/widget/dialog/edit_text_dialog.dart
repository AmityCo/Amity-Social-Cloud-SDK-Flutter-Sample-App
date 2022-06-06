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
      : super(key: key);

  static Future show(BuildContext context,
      {String? title,
      String? defString,
      String? hintText,
      ValueChanged<String>? onChange,
      ValueChanged<String>? onPress}) {
    return showDialog(
        context: context,
        builder: (context) {
          String? text;
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
                  onPress?.call(text!);
                },
                child: const Text('Update'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          );
        });
  }

  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textEditController.text = defString;

    return TextField(
      controller: _textEditController,
      onChanged: onChange,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
