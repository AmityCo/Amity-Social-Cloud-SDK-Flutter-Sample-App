import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:image_picker/image_picker.dart';

class AddCommentWidget extends StatefulWidget {
  AddCommentWidget(
    this._amityUser,
    this.addCommentCallback, {
    Key? key,
    this.communityId,
    this.isPublic = false,
    this.showMediaButton = false,
  }) : super(key: key);
  final AmityUser _amityUser;
  final String? communityId;
  final bool isPublic;
  final bool showMediaButton;
  Function(String comment, List<AmityUser> mentionUsers, List<File> attachments) addCommentCallback;

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final _commentTextEditController = TextEditingController();

  final _commentTextTextFieldKey = GlobalKey();

  final mentionUsers = <AmityUser>[];

  final attachments = <File>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          attachments.isNotEmpty
              ? SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        attachments.length,
                        (index) => Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      attachments[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      attachments.removeAt(index);
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
          if (widget.showMediaButton)
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
                        attachments.add(File(image.path));
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
                        attachments.add(File(image.path));
                      });
                    }
                  },
                  icon: const Icon(Icons.camera),
                  iconSize: 28,
                ),
              ],
            ),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: widget._amityUser.avatarUrl != null
                    ? Image.network(
                        widget._amityUser.avatarUrl!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/user_placeholder.png'),
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

                            _commentTextEditController.selection = TextSelection.fromPosition(
                                TextPosition(offset: _commentTextEditController.text.length));
                          },
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
                        }, communityId: widget.communityId);
                      }
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  final text = _commentTextEditController.text.trim();
                  widget.addCommentCallback(text, List.from(mentionUsers), List.from(attachments));
                  _commentTextEditController.text = '';
                  mentionUsers.clear();
                  attachments.clear();
                  setState(() {});

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
        ],
      ),
    );
  }
}
