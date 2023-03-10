import 'package:flutter/material.dart';

class ShadowContainerWidget extends StatelessWidget {
  const ShadowContainerWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
            ),
          ]),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
