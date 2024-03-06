import 'dart:async';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CreateStoryScreen extends StatefulWidget {
  final AmityStoryTargetType? targetType;
  final String? targetId;
  final bool isVideoType;

  const CreateStoryScreen(
      {Key? key, this.targetType, this.targetId, this.isVideoType = false})
      : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  late BuildContext _context;
  final _targetuserTextEditController = TextEditingController();
  final _customTextEditController = TextEditingController();
  final _hyperLinkEditController = TextEditingController();

  List<String> list = <String>['fit', 'fill'];
  AmityStoryImageDisplayMode amityStoryImageDisplayMode =
      AmityStoryImageDisplayMode.FIT;

  List<File> files = <File>[];

  final _postTextTextFieldKey = GlobalKey();

  final mentionUsers = <AmityUser>[];

  @override
  void initState() {
    if (widget.targetId != null) {
      _targetuserTextEditController.text = widget.targetId!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isCommunityPost = widget.targetId != null;
    var targetLabel = '';
    if (isCommunityPost) {
      targetLabel = 'Target community';
    } else {
      targetLabel = 'Target user';
    }
    return Scaffold(
      appBar: AppBar(
          title:
              Text('Create ${widget.isVideoType ? "Video" : "Image"} Stroy')),
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
                controller: _customTextEditController,
                decoration: const InputDecoration(
                  label: Text('Custom text'),
                ),
                onChanged: (value) {
                  UserSuggesionOverlay.instance.hideOverLay();

                  if (widget.targetId == null || widget.targetId!.isEmpty) {
                    UserSuggesionOverlay.instance.updateOverLay(
                        context,
                        UserSuggestionType.global,
                        _postTextTextFieldKey,
                        value, (keyword, user) {
                      mentionUsers.add(user);
                      if (keyword.isNotEmpty) {
                        final length = _customTextEditController.text.length;
                        _customTextEditController.text =
                            _customTextEditController.text.replaceRange(
                                length - keyword.length,
                                length,
                                user.displayName ?? '');
                      } else {
                        _customTextEditController.text =
                            (_customTextEditController.text +
                                user.displayName!);
                      }

                      _customTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _customTextEditController.text.length));
                    }, postion: UserSuggestionPostion.bottom);
                  } else {
                    UserSuggesionOverlay.instance.updateOverLay(
                        context,
                        UserSuggestionType.community,
                        _postTextTextFieldKey,
                        value, (keyword, user) {
                      mentionUsers.add(user);

                      if (keyword.isNotEmpty) {
                        final length = _customTextEditController.text.length;
                        _customTextEditController.text =
                            _customTextEditController.text.replaceRange(
                                length - keyword.length,
                                length,
                                user.displayName ?? '');
                      } else {
                        _customTextEditController.text =
                            (_customTextEditController.text +
                                user.displayName!);
                      }

                      _customTextEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _customTextEditController.text.length));
                    },
                        communityId: widget.targetId,
                        postion: UserSuggestionPostion.bottom);
                  }
                },
              ),
              TextFormField(
                controller: _hyperLinkEditController,
                decoration: const InputDecoration(
                  label: Text('Hyperlink'),
                ),
              ),
              const SizedBox(height: 20),
              if (!widget.isVideoType)
                Row(
                  children: [
                    const Text('Image Display Mode'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        value: amityStoryImageDisplayMode.value,
                        elevation: 16,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            amityStoryImageDisplayMode =
                                AmityStoryImageDisplayModeExtension.enumOf(
                                    value!);
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(files.length, (index) {
                  final file = files[index];
                  return TextButton.icon(
                      onPressed: () {},
                      icon: Icon(!widget.isVideoType
                          ? Icons.image
                          : Icons.attach_file),
                      label: Text(basename(file.path)),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.blue));
                }),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              const SizedBox(height: 20),
              widget.isVideoType
                  ? TextButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Please Select source'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      files.clear();
                                      final image = await ImagePicker()
                                          .pickVideo(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        files.add(File(image.path));
                                      }
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Gallery'),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      files.clear();
                                      final image = await ImagePicker()
                                          .pickVideo(
                                              source: ImageSource.camera);
                                      if (image != null) {
                                        files.add(File(image.path));
                                      }
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Camera'),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      files.clear();
                                      files.clear();

                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowMultiple: false,
                                              allowedExtensions: [
                                            '3gp',
                                            'avi',
                                            'f4v',
                                            'fly',
                                            'm4v',
                                            'mov',
                                            'mp4',
                                            'ogv',
                                            '3g2',
                                            'wmv',
                                            'vob',
                                            'webm',
                                            'mkv'
                                          ]);

                                      if (result != null) {
                                        files.addAll(result.paths
                                            .map((path) => File(path!))
                                            .toList());
                                      }
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('File'),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'))
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.video_file),
                      label: const Text('Attach Video'),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue))
                  : TextButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Please Select source'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      files.clear();
                                      final image = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (image != null) {
                                        files.add(File(image.path));
                                      }
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Gallery'),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      files.clear();
                                      final image = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      if (image != null) {
                                        files.add(File(image.path));
                                      }
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Camera'),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'))
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Attach Image'),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.blue)),
              const SizedBox(height: 48),
              Center(
                child: TextButton(
                  onPressed: () async {
                    _createStory(context).then((value) {
                      // Navigator.of(context).pop();
                    }).onError((error, stackTrace) {
                      print(error.toString());
                      print(stackTrace.toString());
                      CommonSnackbar.showNagativeSnackbar(
                          context, 'Error', error.toString());
                    });
                     Navigator.of(context).pop();
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
                      (widget.isVideoType)
                          ? const TextSpan(text: ' Video')
                          : const TextSpan(text: ' Image'),
                      const TextSpan(text: ' Story'),
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

  Future _createStory(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (files.isEmpty) {
      throw Exception(
          'Please attach a ${widget.isVideoType ? "Video" : "Image"}');
    }

    AmityStoryItem? storyItem;

    if (_hyperLinkEditController.text.isNotEmpty) {
      storyItem = HyperLink(
          url: _hyperLinkEditController.text,
          customText: _customTextEditController.text);
    }

    if (storyItem == null) {
      if (widget.isVideoType) {
        return AmitySocialClient.newStoryRepository().createVideoStory(
          targetType: widget.targetType!,
          targetId: widget.targetId!,
          videoFile: files[0],
          storyItems: [],
        ).onError((error, stackTrace) {
          CommonSnackbar.showNagativeSnackbar(
              context, 'Error', error.toString());
        });
      } else {
        return AmitySocialClient.newStoryRepository().createImageStory(
            targetType: widget.targetType!,
            targetId: widget.targetId!,
            imageFile: files[0],
            imageDisplayMode: amityStoryImageDisplayMode,
            storyItems: []);
      }
    } else {
      if (widget.isVideoType) {
        return AmitySocialClient.newStoryRepository().createVideoStory(
          targetType: widget.targetType!,
          targetId: widget.targetId!,
          videoFile: files[0],
          storyItems: [storyItem],
        ).onError((error, stackTrace) {
          CommonSnackbar.showNagativeSnackbar(
              context, 'Error', error.toString());
        });
      } else {
        return AmitySocialClient.newStoryRepository().createImageStory(
            targetType: widget.targetType!,
            targetId: widget.targetId!,
            imageFile: files[0],
            imageDisplayMode: amityStoryImageDisplayMode,
            storyItems: [storyItem]);
      }
    }
  }
}
