import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCommentScreen extends StatefulWidget {
  final AmityComment amityComment;
  const UpdateCommentScreen({Key? key, required this.amityComment, required this.communityId, required this.isPublic})
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
  final attachments = <AmityImage>[];
  final localAttachmetns = <File>[];

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
    if (widget.amityComment.attachments != null) {
      attachments.addAll(
        widget.amityComment.attachments!.map((e) => (e as CommentImageAttachment).getImage()!).toList(),
      );
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
    final themeData = Theme.of(context);
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

                if (widget.communityId == null || widget.communityId!.isEmpty || widget.isPublic) {
                  UserSuggesionOverlay.instance.updateOverLay(
                    context,
                    UserSuggestionType.global,
                    _commentTextTextFieldKey,
                    value,
                    (keyword, user) {
                      mentionUsers.add(user);
                      if (keyword.isNotEmpty) {
                        final length = _commentTextEditController.text.length;
                        _commentTextEditController.text = _commentTextEditController.text
                            .replaceRange(length - keyword.length, length, user.displayName ?? '');
                      } else {
                        _commentTextEditController.text = (_commentTextEditController.text + user.displayName!);
                      }

                      _commentTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(offset: _commentTextEditController.text.length));
                    },
                    postion: UserSuggestionPostion.bottom,
                  );
                } else {
                  UserSuggesionOverlay.instance.updateOverLay(
                      context, UserSuggestionType.community, _commentTextTextFieldKey, value, (keyword, user) {
                    mentionUsers.add(user);

                    if (keyword.isNotEmpty) {
                      final length = _commentTextEditController.text.length;
                      _commentTextEditController.text = _commentTextEditController.text
                          .replaceRange(length - keyword.length, length, user.displayName ?? '');
                    } else {
                      _commentTextEditController.text = (_commentTextEditController.text + user.displayName!);
                    }

                    _commentTextEditController.selection =
                        TextSelection.fromPosition(TextPosition(offset: _commentTextEditController.text.length));
                  }, communityId: widget.communityId, postion: UserSuggestionPostion.bottom);
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
            const SizedBox(height: 20),
            if (attachments.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    attachments.length,
                    (index) => Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.red),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.only(right: 6),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                (attachments[index].fileUrl!=null)?
                                Image.network(
                                  attachments[index].fileUrl!,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  fit: BoxFit.cover,
                                ): Container(width: 20 , height: 20 , color: Colors.red,),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        attachments.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.cancel_outlined),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const Spacer(),
            localAttachmetns.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          localAttachmetns.length,
                          (index) => Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.file(
                                        localAttachmetns[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        localAttachmetns.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                    ),
                                  )
                                ],
                              )),
                    ),
                  )
                : Container(),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus!.unfocus();

                    final ImagePicker picker = ImagePicker();
                    // Pick an image
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        localAttachmetns.add(File(image.path));
                      });
                    }
                  },
                  icon: const Icon(Icons.add_a_photo_rounded),
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus!.unfocus();

                    final ImagePicker picker = ImagePicker();
                    // Pick an image
                    final image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        localAttachmetns.add(File(image.path));
                      });
                    }
                  },
                  icon: const Icon(Icons.camera),
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () async {
                  ProgressDialog.show<bool>(context, asyncFunction: updateComment).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  }).onError((error, stackTrace) {
                    if (error is AmityException) {
                      CommonSnackbar.showNagativeSnackbar(context, 'Error', '$error\n${error.data}');
                    } else {
                      CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString());
                    }
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

  Future<bool> updateComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final text = _commentTextEditController.text.trim();
    final metadataString = _commentMetadataEditController.text.trim();
    Map<String, dynamic> metadata = {};

    // if (text.isEmpty) {
    //   CommonSnackbar.showNagativeSnackbar(context, 'Error', 'Please enter text in comment');
    //   return false;
    // }

    if (mentionUsers.isNotEmpty) {
      ///Mention user logic
      //Clean up mention user list, as user might have removed some tagged user
      mentionUsers.removeWhere((element) => !text.contains(element.displayName!));

      // final mentionedUserIds = mentionUsers.map((e) => e.userId!).toList();

      final amityMentioneesMetadata = mentionUsers
          .map<AmityUserMentionMetadata>((e) => AmityUserMentionMetadata(
              userId: e.userId!, index: text.indexOf('@${e.displayName!}'), length: e.displayName!.length))
          .toList();

      metadata = AmityMentionMetadataCreator(amityMentioneesMetadata).create();
    } else {
      try {
        metadata = jsonDecode(metadataString);
      } catch (e) {
        print('metadata decode failed');
      }
    }

    List<CommentImageAttachment> amityImages = [];
    if (localAttachmetns.isNotEmpty) {
      for (var element in localAttachmetns) {
        final image = await waitForUploadComplete(AmityCoreClient.newFileRepository().uploadImage(element).stream);
        amityImages.add(CommentImageAttachment(fileId: image.fileId!));
      }
    }

    amityImages.addAll(attachments.map((e) => CommentImageAttachment(fileId: e.fileId!)));

    await widget.amityComment
        .edit()
        .text(text)
        .metadata(metadata)
        .attachments(amityImages)
        .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
        .build()
        .update();

    return true;
  }

  Future<AmityImage> waitForUploadComplete(Stream<AmityUploadResult> source) {
    final completer = Completer<AmityImage>();
    source.listen((event) {
      event.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) => completer.complete(file),
        error: (error) => completer.completeError(error),
        cancel: () {},
      );
    });
    return completer.future;
  }
}
