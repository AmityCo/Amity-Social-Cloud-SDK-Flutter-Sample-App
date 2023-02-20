import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ChannelUpdateScreen extends StatefulWidget {
  const ChannelUpdateScreen({
    Key? key,
    required this.channelId,
  }) : super(key: key);
  final String channelId;
  @override
  State<ChannelUpdateScreen> createState() => _ChannelUpdateScreenState();
}

class _ChannelUpdateScreenState extends State<ChannelUpdateScreen> {
  final _formState = GlobalKey<FormState>();
  String? avatarUrl;
  final _channelIdEditController = TextEditingController();
  final _nameEditController = TextEditingController();
  final _metadataEditController = TextEditingController();
  final _tagsEditController = TextEditingController();

  XFile? _avatar;
  AmityChannelType? _channelType = AmityChannelType.CONVERSATION;

  @override
  void initState() {
    AmityChatClient.newChannelRepository()
        .getChannel(widget.channelId)
        .then((value) {
      setState(() {
        _channelType = value.amityChannelType;
        avatarUrl = value.avatar?.fileUrl;
        _channelIdEditController.text = value.channelId!;
        _nameEditController.text = value.displayName ?? '';

        _metadataEditController.text =
            value.metadata != null ? jsonEncode(value.metadata) : '';
        _tagsEditController.text = (value.tags?.tags ?? []).join(',');
      });
    }).onError((error, stackTrace) {
      ErrorDialog.show(context, title: 'Error', message: error.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Channel'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formState,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CupertinoSlidingSegmentedControl<AmityChannelType>(
                  groupValue: _channelType,
                  children: const {
                    AmityChannelType.CONVERSATION: Text('Conversation'),
                    AmityChannelType.COMMUNITY: Text('Community'),
                    AmityChannelType.LIVE: Text('Live'),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _channelType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.3)),
                  child: _avatar != null
                      ? Image.file(
                          File(
                            _avatar!.path,
                          ),
                          fit: BoxFit.cover,
                        )
                      : avatarUrl != null
                          ? Image.network(
                              avatarUrl!,
                              fit: BoxFit.fill,
                            )
                          : InkWell(
                              onTap: () async {},
                              child: Stack(
                                children: [
                                  Image.asset('assets/user_placeholder.png'),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 32,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.5),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      // Pick an image
                      final image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      setState(() {
                        _avatar = image;
                      });
                    },
                    child: const Text('Edit Avatar')),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _channelIdEditController,
                  enabled: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter Channel ID (optional)'),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameEditController,
                  decoration:
                      const InputDecoration(hintText: 'Enter Channel Name'),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    controller: _tagsEditController,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter Comma seperated tags',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _metadataEditController,
                  decoration:
                      const InputDecoration(hintText: 'Enter Channel metadata'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _channelType == null
                      ? null
                      : () {
                          ProgressDialog.show(context,
                                  asyncFunction: _updateChannel)
                              .then((value) {
                            GoRouter.of(context).pop();
                          }).onError((error, stackTrace) {
                            ErrorDialog.show(context,
                                title: 'Error', message: error.toString());
                          });
                        },
                  child: const Text('Create Channel'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _updateChannel() async {
    AmityImage? _communityAvatar;
    if (_avatar != null) {
      AmityUploadResult<AmityImage> amityUploadResult =
          await AmityCoreClient.newFileRepository()
              .image(File(_avatar!.path))
              .upload()
              .stream
              .firstWhere((element) => element is AmityUploadComplete);
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        _communityAvatar = amityUploadComplete.getFile as AmityImage;
        // _images.add(amityUploadComplete.getFile as AmityImage);
      }
    }

    // String channeld = _channelIdEditController.text.trim();
    String name = _nameEditController.text.trim();

    final _metadataString = _metadataEditController.text.trim();
    Map<String, dynamic> _metadata = {};
    try {
      _metadata = jsonDecode(_metadataString);
    } catch (e) {
      print('metadata decode failed');
    }

    final builder =
        AmityChatClient.newChannelRepository().updateChannel(widget.channelId);

    if (name.isNotEmpty) builder.displayName(name);

    if (_communityAvatar != null) builder.avatar(_communityAvatar);

    if (_metadata.isNotEmpty) builder.metadata(_metadata);

    if (_tagsEditController.text.isNotEmpty) {
      builder.tags(_tagsEditController.text.trim().split(','));
    }

    await builder.create();
  }
}
