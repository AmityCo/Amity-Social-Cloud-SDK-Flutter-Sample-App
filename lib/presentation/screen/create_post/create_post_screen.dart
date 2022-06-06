import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key, this.userId, this.communityId})
      : super(key: key);
  final String? userId;
  final String? communityId;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late BuildContext _context;

  final _targetuserTextEditController = TextEditingController();
  final _postTextEditController = TextEditingController();
  final _metadataEditController = TextEditingController();

  List<File> files = <File>[];

  bool isTextPost = true;
  bool isImagePost = false;
  bool isFilePost = false;
  bool isVideoPost = false;

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
    final _themeData = Theme.of(context);
    final _isCommunityPost = widget.communityId != null;
    var targetLabel = '';
    if (_isCommunityPost) {
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
                enabled: !_isCommunityPost,
                decoration: InputDecoration(
                  label: Text(targetLabel),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _postTextEditController,
                decoration: const InputDecoration(
                  label: Text('Text*'),
                ),
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
                  final _file = files[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: Icon(isTextPost ? Icons.image : Icons.attach_file),
                      label: Text(basename(_file.path)),
                      style: TextButton.styleFrom(primary: Colors.blue));
                }),
              ),
              const Spacer(),
              const SizedBox(height: 20),
              TextButton.icon(
                  onPressed: () async {
                    files.clear();

                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);

                    if (result != null) {
                      files.addAll(
                          result.paths.map((path) => File(path!)).toList());
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
                  style: TextButton.styleFrom(primary: Colors.blue)),
              const SizedBox(height: 12),
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
                      isFilePost = false;
                      isVideoPost = true;
                    });
                  },
                  icon: const Icon(Icons.video_camera_back_rounded),
                  label: const Text('Attach Video'),
                  style: TextButton.styleFrom(primary: Colors.blue)),
              const SizedBox(height: 12),
              TextButton.icon(
                  onPressed: () async {
                    files.clear();
                    final ImagePicker _picker = ImagePicker();
                    // Pick an image
                    final image = await _picker.pickMultiImage();
                    if (image != null) {
                      files.addAll(image.map((e) => File(e.path)).toList());
                    }

                    setState(() {
                      isTextPost = false;
                      isImagePost = true;
                      isFilePost = false;
                      isVideoPost = false;
                    });
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Attach Image'),
                  style: TextButton.styleFrom(primary: Colors.blue)),
              const SizedBox(height: 48),
              Center(
                child: TextButton(
                  onPressed: () async {
                    ProgressDialog.show(context, asyncFunction: createPost)
                        .then((value) {
                      Navigator.of(context).pop();
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  },
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(text: 'Create'),
                      if (isTextPost) const TextSpan(text: ' Text'),
                      if (isImagePost) const TextSpan(text: ' Image'),
                      if (isFilePost) const TextSpan(text: ' File'),
                      if (isVideoPost) const TextSpan(text: ' Video'),
                      const TextSpan(text: ' Post'),
                    ])),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Future createPost() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final _target = _targetuserTextEditController.text.trim();
    final _text = _postTextEditController.text.trim();
    final _isCommunityPost = widget.communityId != null;
    final _metadataString = _metadataEditController.text.trim();
    Map<String, dynamic> _metadata = {};
    try {
      _metadata = jsonDecode(_metadataString);
    } catch (e) {
      print('metadata decode failed');
    }

    if (isTextPost) {
      if (_isCommunityPost) {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetCommunity(_target)
            .text(_text)
            .metadata(_metadata)
            .post();
      } else {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetUser(_target)
            .text(_text)
            .metadata(_metadata)
            .post();
      }
    }

    if (isImagePost) {
      List<AmityImage> _images = [];
      for (final _file in files) {
        AmityUploadResult<AmityImage> amityUploadResult =
            await AmityCoreClient.newFileRepository().image(_file).upload();
        if (amityUploadResult is AmityUploadComplete) {
          final amityUploadComplete = amityUploadResult as AmityUploadComplete;
          _images.add(amityUploadComplete.getFile as AmityImage);
        }
      }

      if (_isCommunityPost) {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetCommunity(_target)
            .image(_images)
            .text(_text)
            .metadata(_metadata)
            .post();
      } else {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetUser(_target)
            .image(_images)
            .text(_text)
            .metadata(_metadata)
            .post();
      }
    }

    if (isVideoPost) {
      List<AmityVideo> _video = [];
      for (final _file in files) {
        AmityUploadResult<AmityVideo> amityUploadResult =
            await AmityCoreClient.newFileRepository().video(_file).upload();
        if (amityUploadResult is AmityUploadComplete) {
          final amityUploadComplete = amityUploadResult as AmityUploadComplete;
          _video.add(amityUploadComplete.getFile as AmityVideo);
        }
      }

      if (_isCommunityPost) {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetCommunity(_target)
            .video(_video)
            .text(_text)
            .metadata(_metadata)
            .post();
      } else {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetUser(_target)
            .video(_video)
            .text(_text)
            .metadata(_metadata)
            .post();
      }
    }

    if (isFilePost) {
      List<AmityFile> _files = [];
      for (final _file in files) {
        AmityUploadResult<AmityFile> amityUploadResult =
            await AmityCoreClient.newFileRepository().file(_file).upload();
        if (amityUploadResult is AmityUploadComplete) {
          final amityUploadComplete = amityUploadResult as AmityUploadComplete;
          _files.add(amityUploadComplete.getFile as AmityFile);
        }
      }
      if (_isCommunityPost) {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetCommunity(_target)
            .file(_files)
            .text(_text)
            .metadata(_metadata)
            .post();
      } else {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetUser(_target)
            .file(_files)
            .text(_text)
            .metadata(_metadata)
            .post();
      }
    }
  }
}
