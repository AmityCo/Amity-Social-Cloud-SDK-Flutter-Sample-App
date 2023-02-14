import 'dart:convert';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';

class UpdatePostScreen extends StatefulWidget {
  final String? communityId;
  final AmityPost amityPost;
  const UpdatePostScreen({Key? key, required this.amityPost, this.communityId})
      : super(key: key);

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _postTextEditController = TextEditingController();
  final _postMetadataEditController = TextEditingController();

  final _postTextTextFieldKey = GlobalKey();
  final mentionUsers = <AmityUser>[];

  @override
  void initState() {
    if (widget.amityPost.data is TextData) {
      final data = widget.amityPost.data as TextData;
      _postTextEditController.text = data.text ?? '';
    }
    if (widget.amityPost.metadata != null) {
      final metadataString = jsonEncode(widget.amityPost.metadata);
      _postMetadataEditController.text = metadataString;
    }

    if (widget.amityPost.mentionees != null) {
      mentionUsers.addAll(widget.amityPost.mentionees!.map((e) {
        return e.user!;
      }));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Post')),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              key: _postTextTextFieldKey,
              controller: _postTextEditController,
              decoration: const InputDecoration(
                label: Text('Text*'),
              ),
              onChanged: (value) {
                UserSuggesionOverlay.instance.hideOverLay();

                if (widget.communityId == null || widget.communityId!.isEmpty) {
                  UserSuggesionOverlay.instance.updateOverLay(
                    context,
                    UserSuggestionType.global,
                    _postTextTextFieldKey,
                    value,
                    (keyword, user) {
                      mentionUsers.add(user);
                      if (keyword.isNotEmpty) {
                        final length = _postTextEditController.text.length;
                        _postTextEditController.text =
                            _postTextEditController.text.replaceRange(
                                length - keyword.length,
                                length,
                                user.displayName ?? '');
                      } else {
                        _postTextEditController.text =
                            (_postTextEditController.text + user.displayName!);
                      }

                      _postTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _postTextEditController.text.length));
                    },
                  );
                } else {
                  UserSuggesionOverlay.instance.updateOverLay(
                    context,
                    UserSuggestionType.community,
                    _postTextTextFieldKey,
                    value,
                    (keyword, user) {
                      mentionUsers.add(user);

                      if (keyword.isNotEmpty) {
                        final length = _postTextEditController.text.length;
                        _postTextEditController.text =
                            _postTextEditController.text.replaceRange(
                                length - keyword.length,
                                length,
                                user.displayName ?? '');
                      } else {
                        _postTextEditController.text =
                            (_postTextEditController.text + user.displayName!);
                      }

                      _postTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _postTextEditController.text.length));
                    },
                    communityId: widget.communityId,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _postMetadataEditController,
              decoration: const InputDecoration(
                label: Text('Meta data'),
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
                    TextSpan(text: ' Post'),
                  ])),
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
    final text = _postTextEditController.text.trim();
    final metadataString = _postMetadataEditController.text.trim();
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

    await widget.amityPost
        .edit()
        .text(text)
        .metadata(metadata)
        .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
        .build()
        .update();
  }
}
