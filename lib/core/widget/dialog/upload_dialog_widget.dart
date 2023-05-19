import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class UploadProgressDialog extends StatelessWidget {
  final String message;
  final StreamController<UploadInfo> uploadInfoStream;
  const UploadProgressDialog(
      {Key? key, required this.message, required this.uploadInfoStream})
      : super(key: key);

  static void show(BuildContext context,
      StreamController<UploadInfo> uploadInfoStream) async {
    //Show loading overlay
    final overlayState = Navigator.of(context).overlay!;

    final overlayEntryLoader = OverlayEntry(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.black38.withOpacity(.5)),
          alignment: Alignment.center,
          child: UploadProgressDialog(
            message: 'Loading',
            uploadInfoStream: uploadInfoStream,
          ),
        );
      },
    );

    bool overlayVisible = false;
    uploadInfoStream.stream.listen((event) {
      event.uploadInfo.when(
        progress: (uploadInfo, cancelToken) {
          if (overlayEntryLoader.mounted || overlayVisible) {
            overlayVisible = false;
            overlayEntryLoader.remove();
          }

          if (!(overlayEntryLoader.mounted && overlayVisible)) {
            overlayVisible = true;
            overlayState.insert(overlayEntryLoader);
          }
        },
        complete: (file) {
          if (overlayEntryLoader.mounted || overlayVisible) {
            overlayVisible = false;
            overlayEntryLoader.remove();
          }
        },
        error: (error) {
          if (overlayEntryLoader.mounted || overlayVisible) {
            overlayVisible = false;
            overlayEntryLoader.remove();
          }
        },
        cancel: () {
          if (overlayEntryLoader.mounted || overlayVisible) {
            overlayVisible = false;
            overlayEntryLoader.remove();
          }
        },
      );
    });

    // T data;

    // try {
    //   data = await asyncFunction();
    // } on Exception catch (_) {
    //   overlayEntryLoader.remove();
    //   rethrow;
    // }

    // overlayEntryLoader.remove();

    // return data;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Material(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              child: CircularProgressIndicator(),
            ),
            if (message.isNotEmpty) const SizedBox(width: 15.0),
            if (message.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.justify,
                      style: themeData.textTheme.titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    StreamBuilder<UploadInfo>(
                      stream: uploadInfoStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UploadInfo {
  final String fileName;
  final AmityUploadResult uploadInfo;

  UploadInfo(this.fileName, this.uploadInfo);

  @override
  String toString() =>
      'File Name - $fileName \nUpload Info ${uploadInfo.toString()}';
}
