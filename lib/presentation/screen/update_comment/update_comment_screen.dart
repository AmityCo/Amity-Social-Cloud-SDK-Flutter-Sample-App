import 'dart:convert';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';

class UpdateCommentScreen extends StatefulWidget {
  final AmityComment amityComment;
  const UpdateCommentScreen(
      {Key? key,
      required this.amityComment,
      required this.communityId,
      required this.isPublic})
      : super(key: key);
  final String? communityId;
  final bool isPublic;
  @override
  State<UpdateCommentScreen> createState() => _UpdateCommentScreenState();
}

class _UpdateCommentScreenState extends State<UpdateCommentScreen> {
  final _commentTextEditController = TextEditingController();
  final _commentMetadataEditController = TextEditingController();

  final _commentTextTextFieldKey = GlobalKey();
  final mentionUsers = <AmityUser>[];

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

    if (widget.amityComment.mentionees != null) {
      mentionUsers.addAll(widget.amityComment.mentionees!.map((e) {
        return e.user!;
      }));

      super.initState();
    }
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
              key: _commentTextTextFieldKey,
              controller: _commentTextEditController,
              decoration: const InputDecoration(
                label: Text('Text*'),
              ),
              onChanged: (value) {
                UserSuggesionOverlay.instance.hideOverLay();

                if (widget.communityId == null ||
                    widget.communityId!.isEmpty ||
                    widget.isPublic) {
                  UserSuggesionOverlay.instance.updateOverLay(
                    context,
                    UserSuggestionType.global,
                    _commentTextTextFieldKey,
                    value,
                    (keyword, user) {
                      mentionUsers.add(user);
                      if (keyword.isNotEmpty) {
                        final length = _commentTextEditController.text.length;
                        _commentTextEditController.text =
                            _commentTextEditController.text.replaceRange(
                                length - keyword.length,
                                length,
                                user.displayName ?? '');
                      } else {
                        _commentTextEditController.text =
                            (_commentTextEditController.text +
                                user.displayName!);
                      }

                      _commentTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _commentTextEditController.text.length));
                    },
                    postion: UserSuggestionPostion.bottom,
                  );
                } else {
                  UserSuggesionOverlay.instance.updateOverLay(
                      context,
                      UserSuggestionType.community,
                      _commentTextTextFieldKey,
                      value, (keyword, user) {
                    mentionUsers.add(user);

                    if (keyword.isNotEmpty) {
                      final length = _commentTextEditController.text.length;
                      _commentTextEditController.text =
                          _commentTextEditController.text.replaceRange(
                              length - keyword.length,
                              length,
                              user.displayName ?? '');
                    } else {
                      _commentTextEditController.text =
                          (_commentTextEditController.text + user.displayName!);
                    }

                    _commentTextEditController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: _commentTextEditController.text.length));
                  },
                      communityId: widget.communityId,
                      postion: UserSuggestionPostion.bottom);
                }
              },
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
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(text: 'Update'),
                    TextSpan(text: ' Comment'),
                  ])),
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
    final text = _commentTextEditController.text.trim();
    final metadataString = _commentMetadataEditController.text.trim();
    Map<String, dynamic> metadata = {};

    if (mentionUsers.isNotEmpty) {
      ///Mention user logic
      //Clean up mention user list, as user might have removed some tagged user
      mentionUsers
          .removeWhere((element) => !text.contains(element.displayName!));

      // final mentionedUserIds = mentionUsers.map((e) => e.userId!).toList();

      final amityMentioneesMetadata = mentionUsers
          .map<AmityUserMentionMetadata>((e) => AmityUserMentionMetadata(
              userId: e.userId!,
              index: text.indexOf('@${e.displayName!}'),
              length: e.displayName!.length))
          .toList();

      metadata = AmityMentionMetadataCreator(amityMentioneesMetadata).create();
    } else {
      try {
        metadata = jsonDecode(metadataString);
      } catch (e) {
        print('metadata decode failed');
      }
    }

    await widget.amityComment
        .edit()
        .text(text)
        .metadata(metadata)
        .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
        .build()
        .update();
  }
}
