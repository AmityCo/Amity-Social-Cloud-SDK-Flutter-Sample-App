import 'dart:convert';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';

class UpdateCommentScreen extends StatefulWidget {
  final AmityComment amityComment;
  const UpdateCommentScreen({Key? key, required this.amityComment})
      : super(key: key);

  @override
  State<UpdateCommentScreen> createState() => _UpdateCommentScreenState();
}

class _UpdateCommentScreenState extends State<UpdateCommentScreen> {
  final _commentTextEditController = TextEditingController();
  final _commentMetadataEditController = TextEditingController();

  @override
  void initState() {
    if (widget.amityComment.data is CommentTextData) {
      final data = widget.amityComment.data as CommentTextData;
      _commentTextEditController.text = data.text ?? '';
    }
    if (widget.amityComment.metadata != null) {
      final metadataString = jsonEncode(widget.amityComment.metadata);
      _commentMetadataEditController.text = metadataString;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Comment')),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _commentTextEditController,
              decoration: const InputDecoration(
                label: Text('Text*'),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _commentMetadataEditController,
              decoration: const InputDecoration(
                label: Text('Meta data'),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 48),
            Center(
              child: TextButton(
                onPressed: () async {
                  ProgressDialog.show(context, asyncFunction: updateComment)
                      .then((value) {
                    Navigator.of(context).pop();
                  }).onError((error, stackTrace) {
                    CommonSnackbar.showPositiveSnackbar(
                        context, 'Error', error.toString());
                  });
                },
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(text: 'Update'),
                    TextSpan(text: ' Comment'),
                  ])),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future updateComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final _text = _commentTextEditController.text.trim();
    final _metadataString = _commentMetadataEditController.text.trim();
    Map<String, dynamic> _metadata = jsonDecode(_metadataString);

    await widget.amityComment.edit().text(_text).metadata(_metadata).update();
  }
}
