import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';

class UpdatePostScreen extends StatefulWidget {
  final AmityPost amityPost;
  const UpdatePostScreen({Key? key, required this.amityPost}) : super(key: key);

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _postTextEditController = TextEditingController();

  @override
  void initState() {
    if (widget.amityPost.data is TextData) {
      final data = widget.amityPost.data as TextData;
      _postTextEditController.text = data.text ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Post')),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _postTextEditController,
              decoration: const InputDecoration(
                label: Text('Text*'),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 48),
            Center(
              child: TextButton(
                onPressed: () async {
                  ProgressDialog.show(context, asyncFunction: updatePost)
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
                    TextSpan(text: ' Post'),
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

  Future updatePost() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final _text = _postTextEditController.text.trim();

    await widget.amityPost.edit().text(_text).update();
  }
}
