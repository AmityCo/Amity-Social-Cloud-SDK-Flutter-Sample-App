import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class AddCommentWidget extends StatelessWidget {
  AddCommentWidget(this._amityUser, this._addCommentCallback, {Key? key})
      : super(key: key);
  final AmityUser _amityUser;
  final _commentTextEditController = TextEditingController();
  final ArgumentCallback<String> _addCommentCallback;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            child: _amityUser.avatarUrl != null
                ? Image.network(
                    _amityUser.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.shade300,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: TextFormField(
                controller: _commentTextEditController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: 'Write your comment here',
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              final text = _commentTextEditController.text.trim();
              _addCommentCallback.call(text);
              _commentTextEditController.text = '';
              // _amityPost
              //     .comment()
              //     .create()
              //     .text(_commentTextEditController.text.trim())
              //     .send();
            },
            icon: const Icon(Icons.send_rounded),
            iconSize: 28,
          )
        ],
      ),
    );
  }
}
