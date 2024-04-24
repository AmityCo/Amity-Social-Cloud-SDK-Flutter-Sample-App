import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/upload_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class CreateLiveStreamPostScreen extends StatefulWidget {
  const CreateLiveStreamPostScreen(
      {Key? key, this.userId, this.communityId, this.isPublic = false})
      : super(key: key);
  final String? userId;
  final String? communityId;
  final bool isPublic;

  @override
  State<CreateLiveStreamPostScreen> createState() => _CreateLiveStreamPostScreenState();
}

class _CreateLiveStreamPostScreenState extends State<CreateLiveStreamPostScreen> {
  late BuildContext _context;

  final _targetuserTextEditController = TextEditingController();
  final _metadataEditController = TextEditingController();
  final _postTextEditController = TextEditingController();
  final _liveStreamIdEditController = TextEditingController();

  final _postTextTextFieldKey = GlobalKey();

  final mentionUsers = <AmityUser>[];

  @override
  void initState() {
    if (widget.userId != null) {
      _targetuserTextEditController.text = widget.userId!;
    }
    if (widget.communityId != null) {
      _targetuserTextEditController.text = widget.communityId!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isCommunityPost = widget.communityId != null;
    var targetLabel = '';
    if (isCommunityPost) {
      targetLabel = 'Target community';
    } else {
      targetLabel = 'Target user';
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Create Livestream Post')),
      body: Builder(builder: (context) {
        _context = context;
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _targetuserTextEditController,
                enabled: !isCommunityPost,
                decoration: InputDecoration(
                  label: Text(targetLabel),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: _postTextTextFieldKey,
                controller: _postTextEditController,
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
                        _postTextTextFieldKey,
                        value, (keyword, user) {
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
                    }, postion: UserSuggestionPostion.bottom);
                  } else {
                    UserSuggesionOverlay.instance.updateOverLay(
                        context,
                        UserSuggestionType.community,
                        _postTextTextFieldKey,
                        value, (keyword, user) {
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
                        postion: UserSuggestionPostion.bottom);
                  }
                },
              ),
              TextFormField(
                controller: _metadataEditController,
                decoration: const InputDecoration(
                  label: Text('Metadata'),
                ),
              ),
              TextFormField(
                controller: _liveStreamIdEditController,
                decoration: const InputDecoration(
                  label: Text('StreamId'),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: TextButton(
                  onPressed: () async {
                    ProgressDialog.show(
                      context,
                      asyncFunction: () => _createPost(context),
                    ).then((value) {
                      PositiveDialog.show(context,
                          title: 'Post Created',
                          message: 'Post Created Successfully',
                          onPostiveCallback: () {
                        GoRouter.of(context).pop();
                      });
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: RichText(
                        text: const TextSpan(text: 'Create LiveStream Post')),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Future _createPost(BuildContext context) async {
    final uploadInfoStream = StreamController<UploadInfo>.broadcast();
    UploadProgressDialog.show(context, uploadInfoStream);

    FocusManager.instance.primaryFocus?.unfocus();
    final target = _targetuserTextEditController.text.trim();
    final text = _postTextEditController.text.trim();
    final isCommunityPost = widget.communityId != null;
    final steramId = _liveStreamIdEditController.text.trim();

    ///Mention user logic
    //Clean up mention user list, as user might have removed some tagged user
    mentionUsers.removeWhere((element) => !text.contains(element.displayName!));

    final mentionedUserIds = mentionUsers.map((e) => e.userId!).toList();

    final amityMentioneesMetadata = mentionUsers
        .map<AmityUserMentionMetadata>((e) => AmityUserMentionMetadata(
            userId: e.userId!,
            index: text.indexOf('@${e.displayName!}'),
            length: e.displayName!.length))
        .toList();

    Map<String, dynamic> metadata =
        AmityMentionMetadataCreator(amityMentioneesMetadata).create();

    if (isCommunityPost) {
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetCommunity(target)
          .liveStream(steramId)
          .text(text)
          .mentionUsers(mentionedUserIds)
          .metadata(metadata)
          .post();
    } else {

      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetCommunity(target)
          .liveStream(text)
          .text(text)
          .mentionUsers(mentionedUserIds)
          .metadata(metadata)
          .post();
    }

  }
}
