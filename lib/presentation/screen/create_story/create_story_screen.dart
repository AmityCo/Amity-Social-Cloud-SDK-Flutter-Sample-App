import 'dart:async';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreateStoryScreen extends StatefulWidget {
  final String? userId;
  final String? communityId;

  const CreateStoryScreen({Key? key, this.userId, this.communityId})
      : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  late BuildContext _context;
  final _targetuserTextEditController = TextEditingController();
  final _postTextEditController = TextEditingController();
  final _metadataEditController = TextEditingController();

  List<File> files = <File>[];

  bool isTextPost = true;
  bool isImagePost = false;
  bool isVideoPost = false;

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
      appBar: AppBar(title: const Text('Create Post')),
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
                      widget.communityId!.isEmpty) {
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
              const SizedBox(height: 20),
              Column(
                children: List.generate(files.length, (index) {
                  final file = files[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: Icon(isTextPost ? Icons.image : Icons.attach_file),
                      label: Text(basename(file.path)),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.blue));
                }),
              ),
              const Spacer(),
              const SizedBox(height: 20),
              TextButton.icon(
                  onPressed: () async {
                    files.clear();

                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: true,
                            allowedExtensions: ['mp4', 'mov']);

                    if (result != null) {
                      files.addAll(
                          result.paths.map((path) => File(path!)).toList());
                    }
                    setState(() {
                      isTextPost = false;
                      isImagePost = false;
                      isVideoPost = true;
                    });
                  },
                  icon: const Icon(Icons.video_file),
                  label: const Text('Attach Video'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue)),
              const SizedBox(height: 12),
              TextButton.icon(
                  onPressed: () async {
                    files.clear();
                    final ImagePicker picker = ImagePicker();
                    // Pick an image
                    final image = await picker.pickMultiImage();
                    files.addAll(image.map((e) => File(e.path)).toList());

                    setState(() {
                      isTextPost = false;
                      isImagePost = true;
                      isVideoPost = false;
                    });
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Attach Image'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue)),
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
                        text: TextSpan(children: [
                      const TextSpan(text: 'Create'),
                      if (isTextPost) const TextSpan(text: ' Text'),
                      if (isImagePost) const TextSpan(text: ' Image'),
                      if (isVideoPost) const TextSpan(text: ' Video'),
                      const TextSpan(text: ' Post'),
                    ])),
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
    FocusManager.instance.primaryFocus?.unfocus();
    final target = _targetuserTextEditController.text.trim();
    final text = _postTextEditController.text.trim();
    final isCommunityPost = widget.communityId != null;
    // final _metadataString = _metadataEditController.text.trim();

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

    // if (isTextPost) {
    //   if (isCommunityPost) {
    //     await AmitySocialClient.newPostRepository()
    //         .createPost()
    //         .targetCommunity(target)
    //         .text(text)
    //         .mentionUsers(mentionedUserIds)
    //         .metadata(metadata)
    //         .post();
    //   } else {
    //     await AmitySocialClient.newPostRepository()
    //         .createPost()
    //         .targetUser(target)
    //         .text(text)
    //         .mentionUsers(mentionedUserIds)
    //         .metadata(metadata)
    //         .post();
    //   }
    // }

    if (isImagePost) {
      if (files.isNotEmpty) {}

      if (isCommunityPost) {
        await AmitySocialClient.newStoryRepository().createImageStory(
            targetType: AmityStoryTargetType.COMMUNITY,
            targetId: widget.communityId!,
            imageFile: files[0],
            imageDisplayMode: AmityStoryImageDisplayMode.FILL);
      }
    }

    if (isVideoPost) {
      if (files.isNotEmpty) {

      }

      if (isCommunityPost) {
        await AmitySocialClient.newStoryRepository().createVideoStory(
          targetType: AmityStoryTargetType.COMMUNITY,
          targetId: widget.communityId!,
          videoFile: files[0],
        );
      }
    }
  }


}
