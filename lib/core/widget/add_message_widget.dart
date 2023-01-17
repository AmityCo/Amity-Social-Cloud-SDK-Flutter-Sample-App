import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:image_picker/image_picker.dart';

class AddMessageWidget extends StatefulWidget {
  const AddMessageWidget(
      this._channelId, this._amityUser, this._addCommentCallback,
      {Key? key})
      : super(key: key);
  final String _channelId;
  final AmityUser _amityUser;
  final ValueChanged<MessageData> _addCommentCallback;

  @override
  State<AddMessageWidget> createState() => _AddMessageWidgetState();
}

class _AddMessageWidgetState extends State<AddMessageWidget>
    with WidgetsBindingObserver {
  final _commentTextFieldKey = GlobalKey();
  final _commentTextEditController = TextEditingController();

  // final ValueChanged<File> _addImageCallback;
  File? _selectedImage;
  File? _selectedFile;
  List<MentionData>? _amityMentionMetadata;

  final _focusNode = FocusNode();

  final _debouncer = Debouncer(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        hideOverLay();
      } else {
        // Future.delayed(const Duration(seconds: 2), updateOverLay);
      }
    });
    // Used to obtain the change of the window size to determine whether the keyboard is hidden.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // stop Observing the window size changes.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _debouncer.run(() {
      if (WidgetsBinding.instance.window.viewInsets.bottom != 0.0) {
        // Keyboard is visible.
        updateOverLay();
      } else {
        // Keyboard is not visible.
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (suggestionTagoverlayEntry != null) {
          suggestionTagoverlayEntry!.remove();
          suggestionTagoverlayEntry = null;
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _selectedImage != null
              ? Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    )
                  ],
                )
              : Container(),
          _selectedFile != null
              ? ListTile(
                  leading: const Icon(Icons.attach_file_rounded),
                  title: Text(_selectedFile!.path.split('/').last),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedFile = null;
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                  tileColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              : Container(),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus!.unfocus();

                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setState(() {
                          _selectedFile = File(result.paths.first!);
                          _selectedImage = null;
                        });
                      }
                    },
                    icon: const Icon(Icons.file_present_outlined),
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus!.unfocus();

                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      final image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                          _selectedFile = null;
                        });
                      }
                    },
                    icon: const Icon(Icons.add_a_photo_rounded),
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus!.unfocus();

                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      final image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          _selectedImage = File(image.path);
                          _selectedFile = null;
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.3),
                    ),
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
                      constraints: BoxConstraints(maxHeight: 100),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.grey.shade300,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: TextFormField(
                        key: _commentTextFieldKey,
                        controller: _commentTextEditController,
                        focusNode: _focusNode,
                        // maxLength: 20000,
                        maxLines: 10,
                        minLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: 'Write your message here',
                        ),
                        onChanged: (value) {
                          hideOverLay();

                          updateOverLay();
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      final text = _commentTextEditController.text.trim();

                      if (text.isEmpty &&
                          _selectedImage == null &&
                          _selectedFile == null) {
                        CommonSnackbar.showNagativeSnackbar(
                          context,
                          'Error',
                          'Please enter message',
                          duration: const Duration(seconds: 1),
                        );
                        return;
                      }
                      widget._addCommentCallback.call(
                        MessageData(
                          message: text,
                          image: _selectedImage,
                          file: _selectedFile,
                          amityMentionMetadata: _amityMentionMetadata,
                        ),
                      );
                      _commentTextEditController.text = '';
                      _selectedImage = null;
                      _selectedFile = null;
                      _amityMentionMetadata = null;
                    },
                    icon: const Icon(Icons.send_rounded),
                    iconSize: 28,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateOverLay() {
    final value = _commentTextEditController.text.trim();
    final regex = RegExp(r"\@[\w\-\_\.]*$");
    if (regex.hasMatch(value)) {
      final match = regex.allMatches(value).last;
      showOverlaidTag(
          context, value, match.group(0)!.replaceAll('@', ''), match.start);
    }
  }

  void hideOverLay() {
    if (suggestionTagoverlayEntry != null) {
      suggestionTagoverlayEntry!.remove();
      suggestionTagoverlayEntry = null;
    }
  }

  OverlayEntry? suggestionTagoverlayEntry;
  showOverlaidTag(BuildContext context, String newText, String keyword,
      int startIndex) async {
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: newText,
      ),
    );
    painter.layout();
    final width = MediaQuery.of(context).size.width;
    final overlayState = Overlay.of(context);

    TextPosition cursorTextPosition = _commentTextEditController.selection.base;
    Rect caretPrototype = const Rect.fromLTWH(0.0, 0.0, 0.0, 0.0);
    Offset caretOffset =
        painter.getOffsetForCaret(cursorTextPosition, caretPrototype);

    // final left = caretOffset.dx % 100;
    // final top = caretOffset.dy - 200;

    final renderBox =
        _commentTextFieldKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    final left = position.dx;
    final top = position.dy - 200;

    if (suggestionTagoverlayEntry == null) {
      suggestionTagoverlayEntry = OverlayEntry(builder: (context) {
        return Positioned(
          left: left,
          top: top,
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ChannelMemberSuggestionWidget(
                      channelId: widget._channelId,
                      keyword: keyword,
                      onUserSelect: (value) {
                        hideOverLay();

                        _commentTextEditController.text =
                            _commentTextEditController.text
                                .trim()
                                .replaceAll(keyword, '');

                        _amityMentionMetadata ??= [];
                        if (value.amityMentionType ==
                            AmityMentionType.CHANNEL) {
                          _amityMentionMetadata!.add(
                            MentionData(AmityMentionType.CHANNEL.value,
                                startIndex, 'all'.length,
                                displayName: 'all'),
                          );
                          _commentTextEditController.text =
                              '${_commentTextEditController.text.trim()}all';
                        } else {
                          _amityMentionMetadata!.add(
                            MentionData(
                              AmityMentionType.USER.value,
                              startIndex,
                              value.amityChannelMember!.user!.displayName!
                                  .length,
                              userId: value.amityChannelMember!.userId!,
                              displayName:
                                  value.amityChannelMember!.user!.displayName!,
                            ),
                          );
                          _commentTextEditController.text =
                              '${_commentTextEditController.text.trim()}${value.amityChannelMember!.user!.displayName}';
                        }

                        _commentTextEditController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset:
                                    _commentTextEditController.text.length));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
      overlayState!.insert(suggestionTagoverlayEntry!);
    }
  }
}

class MessageData {
  String? message;
  File? image;
  File? file;
  List<MentionData>? amityMentionMetadata;
  MessageData({this.message, this.image, this.file, this.amityMentionMetadata});
}

class MentionData {
  final String mentionType;
  final String? userId;
  final String? displayName;
  final int index;
  final int length;

  MentionData(
    this.mentionType,
    this.index,
    this.length, {
    this.userId,
    this.displayName,
  });

  AmityMentionMetadata amityMentionMetaData(int index) => mentionType ==
          AmityMentionType.USER.value
      ? AmityUserMentionMetadata(userId: userId!, index: index, length: length)
      : AmityChannelMentionMetadata(index: index, length: length);
}

class ChannelMemberSuggestionWidget extends StatelessWidget {
  const ChannelMemberSuggestionWidget(
      {Key? key,
      required this.channelId,
      required this.keyword,
      required this.onUserSelect})
      : super(key: key);
  final String channelId;
  final String keyword;
  final ValueChanged<ChannelMemberTagData> onUserSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
      ),
      child: FutureBuilder<List<AmityChannelMember>>(
        future: AmityChannelRepository()
            .membership(channelId)
            .searchMembers(keyword)
            .query(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    foregroundImage: NetworkImage(''),
                  ),
                  title: const Text('All'),
                  dense: true,
                  onTap: () {
                    onUserSelect(
                        ChannelMemberTagData(AmityMentionType.CHANNEL));
                  },
                ),
                ...List.generate(
                  snapshot.data!.length,
                  (index) {
                    final amityMember = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage:
                            NetworkImage(amityMember.user!.avatarUrl ?? ''),
                      ),
                      title: Text(amityMember.user!.userId!),
                      dense: true,
                      onTap: () {
                        onUserSelect(ChannelMemberTagData(AmityMentionType.USER,
                            amityChannelMember: amityMember));
                      },
                    );
                  },
                )
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChannelMemberTagData {
  final AmityMentionType amityMentionType;
  final AmityChannelMember? amityChannelMember;

  ChannelMemberTagData(this.amityMentionType, {this.amityChannelMember});
}
