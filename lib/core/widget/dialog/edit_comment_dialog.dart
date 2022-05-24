import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class EditCommentDialog extends StatelessWidget {
  final AmityComment amityComment;
  final ValueChanged onChange;
  EditCommentDialog(
      {Key? key, required this.amityComment, required this.onChange})
      : super(key: key);

  static Future show(BuildContext context,
      {required AmityComment amityComment}) {
    return showDialog(
        context: context,
        builder: (context) {
          String? text;
          return AlertDialog(
            title: const Text('Edit Comment Text'),
            content: EditCommentDialog(
              amityComment: amityComment,
              onChange: (value) {
                text = value;
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
                  // GoRouter.of(context).goNamed(AppRoute.login);
                  Navigator.of(context).pop();
                  amityComment.edit().text(text!).build().update();
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
    AmityCommentData data = amityComment.data!;
    if (data is CommentTextData) _textEditController.text = data.text!;

    return TextField(
      controller: _textEditController,
      onChanged: onChange,
    );
  }
}
