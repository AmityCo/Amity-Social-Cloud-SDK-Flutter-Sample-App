import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:image_picker/image_picker.dart';

class AddMessageWidget extends StatefulWidget {
  AddMessageWidget(this._amityUser, this._addCommentCallback, {Key? key})
      : super(key: key);
  final AmityUser _amityUser;
  final ValueChanged<MessageData> _addCommentCallback;

  @override
  State<AddMessageWidget> createState() => _AddMessageWidgetState();
}

class _AddMessageWidgetState extends State<AddMessageWidget> {
  final _commentTextEditController = TextEditingController();

  // final ValueChanged<File> _addImageCallback;
  File? _selectedImage;
  File? _selectedFile;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      borderRadius: BorderRadius.circular(12)),
                )
              : Container(),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                child: widget._amityUser.avatarUrl != null
                    ? Image.network(
                        widget._amityUser.avatarUrl!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/user_placeholder.png'),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.grey.shade300,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: TextFormField(
                    controller: _commentTextEditController,
                    // maxLength: 20000,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: 'Write your message here',
                    ),
                  ),
                ),
              ),
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
                  widget._addCommentCallback.call(MessageData(
                      message: text,
                      image: _selectedImage,
                      file: _selectedFile));
                  _commentTextEditController.text = '';
                  _selectedImage = null;
                  _selectedFile = null;
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

class MessageData {
  String? message;
  File? image;
  File? file;
  MessageData({this.message, this.image, this.file});
}
