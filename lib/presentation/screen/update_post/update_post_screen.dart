import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UpdatePostScreen extends StatefulWidget {
  final String? communityId;
  final bool isPublic;
  final AmityPost amityPost;
  const UpdatePostScreen({Key? key, required this.amityPost, this.communityId, required this.isPublic})
      : super(key: key);

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _postTextEditController = TextEditingController();
  final _postMetadataEditController = TextEditingController();

  final _postTextTextFieldKey = GlobalKey();
  final mentionUsers = <AmityUser>[];

  List<File> files = <File>[];

  bool isTextPost = true;
  bool isImagePost = false;
  bool isFilePost = false;
  bool isVideoPost = false;

  List<AmityPost> imagePost = [];
  List<AmityPost> filePost = [];
  List<AmityPost> videoPost = [];

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

    if ((widget.amityPost.children ?? []).isNotEmpty) {
      imagePost = widget.amityPost.children!.where((element) => element.type == AmityDataType.IMAGE).toList();
      isImagePost = imagePost.isNotEmpty;

      filePost = widget.amityPost.children!.where((element) => element.type == AmityDataType.FILE).toList();
      isFilePost = filePost.isNotEmpty;

      videoPost = widget.amityPost.children!.where((element) => element.type == AmityDataType.VIDEO).toList();
      isVideoPost = videoPost.isNotEmpty;
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
        child: ListView(
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

                if (widget.communityId == null || widget.communityId!.isEmpty || widget.isPublic) {
                  UserSuggesionOverlay.instance
                      .updateOverLay(context, UserSuggestionType.global, _postTextTextFieldKey, value, (keyword, user) {
                    mentionUsers.add(user);
                    if (keyword.isNotEmpty) {
                      final length = _postTextEditController.text.length;
                      _postTextEditController.text = _postTextEditController.text
                          .replaceRange(length - keyword.length, length, user.displayName ?? '');
                    } else {
                      _postTextEditController.text = (_postTextEditController.text + user.displayName!);
                    }

                    _postTextEditController.selection =
                        TextSelection.fromPosition(TextPosition(offset: _postTextEditController.text.length));
                  }, postion: UserSuggestionPostion.bottom);
                } else {
                  UserSuggesionOverlay.instance.updateOverLay(
                      context, UserSuggestionType.community, _postTextTextFieldKey, value, (keyword, user) {
                    mentionUsers.add(user);

                    if (keyword.isNotEmpty) {
                      final length = _postTextEditController.text.length;
                      _postTextEditController.text = _postTextEditController.text
                          .replaceRange(length - keyword.length, length, user.displayName ?? '');
                    } else {
                      _postTextEditController.text = (_postTextEditController.text + user.displayName!);
                    }

                    _postTextEditController.selection =
                        TextSelection.fromPosition(TextPosition(offset: _postTextEditController.text.length));
                  }, communityId: widget.communityId, postion: UserSuggestionPostion.bottom);
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
            const SizedBox(height: 12),

            ///Post Image
            if (isImagePost)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(imagePost.length, (index) {
                  final _post = imagePost[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: IconButton(
                        onPressed: () {
                          imagePost.remove(_post);
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      label: Text(basename((_post.data as ImageData).image!.fileName!)),
                      style: TextButton.styleFrom(primary: Colors.blue));
                })
                  ..insert(
                    0,
                    Container(margin: const EdgeInsets.symmetric(vertical: 6), child: const Text('Post Image')),
                  ),
              ),

            ///Post Video
            if (isVideoPost)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(imagePost.length, (index) {
                  final _post = videoPost[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: IconButton(
                        onPressed: () {
                          videoPost.remove(_post);
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      label: Text(basename((_post.data as ImageData).image!.fileName!)),
                      style: TextButton.styleFrom(primary: Colors.blue));
                })
                  ..insert(
                    0,
                    Container(margin: const EdgeInsets.symmetric(vertical: 6), child: const Text('Post Image')),
                  ),
              ),

            ///Post Image
            if (isFilePost)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(imagePost.length, (index) {
                  final _post = filePost[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: IconButton(
                        onPressed: () {
                          filePost.remove(_post);
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      label: Text(basename((_post.data as ImageData).image!.fileName!)),
                      style: TextButton.styleFrom(primary: Colors.blue));
                })
                  ..insert(
                    0,
                    Container(margin: const EdgeInsets.symmetric(vertical: 6), child: const Text('Post Image')),
                  ),
              ),
            if (files.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(files.length, (index) {
                  final file = files[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: IconButton(
                        onPressed: () {
                          files.remove(file);
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      label: Text(basename(file.path)),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue));
                })
                  ..insert(
                    0,
                    Container(margin: const EdgeInsets.symmetric(vertical: 6), child: const Text('Local File')),
                  ),
              ),
            const SizedBox(height: 20),
            if (isFilePost)
              TextButton.icon(
                  onPressed: () async {
                    files.clear();

                    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                    if (result != null) {
                      files.addAll(result.paths.map((path) => File(path!)).toList());
                    }
                    setState(() {
                      isTextPost = false;
                      isImagePost = false;
                      isFilePost = true;
                      isVideoPost = false;
                    });
                  },
                  icon: const Icon(Icons.attach_file_outlined),
                  label: const Text('Attach File'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue)),
            if (isFilePost) const SizedBox(height: 12),
            if (isVideoPost)
              TextButton.icon(
                  onPressed: () async {
                    files.clear();

                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.custom, allowMultiple: true, allowedExtensions: ['mp4', 'mov']);

                    if (result != null) {
                      files.addAll(result.paths.map((path) => File(path!)).toList());
                    }
                    setState(() {
                      isTextPost = false;
                      isImagePost = false;
                      isFilePost = false;
                      isVideoPost = true;
                    });
                  },
                  icon: const Icon(Icons.video_file),
                  label: const Text('Attach Video'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue)),
            if (isVideoPost) const SizedBox(height: 12),
            if (isTextPost || isImagePost)
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
                      isFilePost = false;
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
                  ProgressDialog.show(context, asyncFunction: updatePost).then((value) {
                    Navigator.of(context).pop();
                  }).onError((error, stackTrace) {
                    CommonSnackbar.showPositiveSnackbar(context, 'Error', error.toString());
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

    if (isImagePost) {
      final attachments = <AmityImage>[];

      attachments.addAll(imagePost.map((e) => (e.data as ImageData).image!));

      if (files.isNotEmpty) {
        for (var file in files) {
          final image = await waitForImageUploadComplete(AmityCoreClient.newFileRepository().uploadImage(file).stream);
          attachments.add(image);
        }
      }

      await widget.amityPost
          .edit()
          .text(text)
          .image(attachments)
          .metadata(metadata)
          .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
          .build()
          .update();

      return;
    }

    if (isVideoPost) {
      final attachments = <AmityVideo>[];

      attachments
          .addAll(videoPost.map((e) => AmityVideo(AmityFileProperties()..fileId = (e.data as VideoData).fileId)));

      if (files.isNotEmpty) {
        for (var file in files) {
          final video = await waitForVideoUploadComplete( AmityCoreClient.newFileRepository().uploadVideo(file , feedtype:AmityContentFeedType.POST).stream);
          attachments.add(video);
        }
      }

      await widget.amityPost
          .edit()
          .text(text)
          .video(attachments)
          .metadata(metadata)
          .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
          .build()
          .update();
      return;
    }

    if (isFilePost) {
      final attachments = <AmityFile>[];

      attachments.addAll(filePost.map((e) => AmityFile(AmityFileProperties()..fileId = (e.data as VideoData).fileId)));

      if (files.isNotEmpty) {
        for (var file in files) {
          final amityFile =
              await waitForFileUploadComplete(AmityCoreClient.newFileRepository().uploadImage(file).stream);
          attachments.add(amityFile);
        }
      }

      await widget.amityPost
          .edit()
          .text(text)
          .file(attachments)
          .metadata(metadata)
          .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
          .build()
          .update();

      return;
    }

    if (isTextPost) {
      await widget.amityPost
          .edit()
          .text(text)
          .metadata(metadata)
          .mentionUsers(mentionUsers.map((e) => e.userId!).toList())
          .build()
          .update();

      return;
    }
  }

  Future<AmityImage> waitForImageUploadComplete(Stream<AmityUploadResult> source) {
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

  Future<AmityVideo> waitForVideoUploadComplete(Stream<AmityUploadResult> source) {
    final completer = Completer<AmityVideo>();
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

  Future<AmityFile> waitForFileUploadComplete(Stream<AmityUploadResult> source) {
    final completer = Completer<AmityFile>();
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
