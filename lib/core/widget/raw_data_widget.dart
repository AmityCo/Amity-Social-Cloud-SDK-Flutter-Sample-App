import 'dart:convert';

import 'package:flutter/material.dart';

class RawDataWidget extends StatefulWidget {
  const RawDataWidget({super.key, required this.jsonRawData});
  final String jsonRawData;
  @override
  State<RawDataWidget> createState() => _RawDataWidgetState();
}

class _RawDataWidgetState extends State<RawDataWidget> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Text(
                'Tap to ${hide ? 'see' : 'hide'} Raw Data',
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 12),
          AnimatedContainer(
            height: hide ? 0 : null,
            duration: const Duration(milliseconds: 500),
            child: Text(const JsonEncoder.withIndent('  ')
                .convert(json.decode(widget.jsonRawData))),
          ),
        ],
      ),
    );
  }
}
