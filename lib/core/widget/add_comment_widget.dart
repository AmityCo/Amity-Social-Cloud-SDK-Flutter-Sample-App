import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';

class AddCommentWidget extends StatelessWidget {
  AddCommentWidget(this._amityUser, this.addCommentCallback, {Key? key})
      : super(key: key);
  final AmityUser _amityUser;
  final _commentTextEditController = TextEditingController();
  final _commentTextTextFieldKey = GlobalKey();
  final mentionUsers = <AmityUser>[];
  Function(String comment, List<AmityUser> mentionUsers) addCommentCallback;
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
                key: _commentTextTextFieldKey,
                controller: _commentTextEditController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: 'Write your comment here',
                ),
                onChanged: (value) {
                  if (value.length > 3) {
                    UserSuggesionOverlay.instance.hideOverLay();

                    UserSuggesionOverlay.instance.updateOverLay(
                      context,
                      _commentTextTextFieldKey,
                      value,
                      (keyword, user) {
                        mentionUsers.add(user);
                        _commentTextEditController.text =
                            _commentTextEditController.text
                                .replaceAll(keyword, user.displayName ?? '');

                        _commentTextEditController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    _commentTextEditController.text.length));
                      },
                    );
                  }
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              final text = _commentTextEditController.text.trim();
              this.addCommentCallback(text, mentionUsers);
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
