import 'dart:async';

import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String message;
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  static Future<T> show<T>(BuildContext context,
      {required Future<T> Function() asyncFunction, Widget? loadingWidget}) async {
    //Show loading overlay
    final overlayState = Navigator.of(context).overlay!;

    final overlayEntryLoader = OverlayEntry(
      builder: (context) {
        return loadingWidget ??
            Container(
              decoration: BoxDecoration(color: Colors.black38.withOpacity(.5)),
              alignment: Alignment.center,
              child: const ProgressDialog(
                message: 'Loading',
              ),
            );
      },
    );

    overlayState.insert(overlayEntryLoader);

    T data;

    try {
      data = await asyncFunction();
    } on Exception catch (_) {
      overlayEntryLoader.remove();
      rethrow;
    }

    overlayEntryLoader.remove();
    return data;
  }

  static Future<T> showCompleter<T>(BuildContext context, Completer completer, {String message = ''}) async {
    //Show loading overlay
    final overlayState = Navigator.of(context).overlay!;

    final overlayEntryLoader = OverlayEntry(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.black38.withOpacity(.5)),
          alignment: Alignment.center,
          child: ProgressDialog(
            message: message,
          ),
        );
      },
    );

    overlayState.insert(overlayEntryLoader);

    T data;

    try {
      data = await completer.future;
    } on Exception catch (_) {
      overlayEntryLoader.remove();
      rethrow;
    }

    overlayEntryLoader.remove();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            child: CircularProgressIndicator(),
          ),
          if (message.isNotEmpty) const SizedBox(width: 15.0),
          if (message.isNotEmpty)
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.justify,
                style: themeData.textTheme.titleMedium!.copyWith(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
