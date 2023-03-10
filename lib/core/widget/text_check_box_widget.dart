import 'package:flutter/material.dart';

class TextCheckBox extends StatefulWidget {
  const TextCheckBox(
      {super.key,
      required this.title,
      required this.value,
      required this.onChanged});
  final String title;
  final bool value;
  final Function(bool?) onChanged;
  @override
  State<TextCheckBox> createState() => _TextCheckBoxState();
}

class _TextCheckBoxState extends State<TextCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
        Text(widget.title),
      ],
    );
  }
}
