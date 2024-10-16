import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChannelCreateScreen extends StatefulWidget {
  const ChannelCreateScreen({
    Key? key,
    this.userIds = const [],
  }) : super(key: key);
  final List<String>? userIds;
  @override
  State<ChannelCreateScreen> createState() => _ChannelCreateScreenState();
}

class _ChannelCreateScreenState extends State<ChannelCreateScreen> {
  final _formState = GlobalKey<FormState>();

  final _channelIdEditController = TextEditingController();
  final _nameEditController = TextEditingController();
  final _userIdsEditController = TextEditingController();
  final _metadataEditController = TextEditingController();
  final _tagsEditController = TextEditingController();

  XFile? _avatar;
  AmityChannelType? _channelType = AmityChannelType.CONVERSATION;

  @override
  void initState() {
    if (widget.userIds != null) {
      _userIdsEditController.text = widget.userIds!.join(',');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: _avatar != null
                      ? Image.file(
                          File(
                            _avatar!.path,
                          ),
                          fit: BoxFit.cover,
                        )
                      : InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image

                            final image = await picker.pickImage(source: ImageSource.gallery);

                            setState(() {
                              _avatar = image;
                            });
                          },
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
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _channelIdEditController,
                  decoration: const InputDecoration(hintText: 'Enter Channel ID (optional)'),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameEditController,
                  decoration: const InputDecoration(hintText: 'Enter Channel Name'),
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
                SizedBox(
                  height: 100,
                  child: TextFormField(
                    controller: _userIdsEditController,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter Comma seperated user Ids',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _metadataEditController,
                  decoration: const InputDecoration(hintText: 'Enter Channel metadata'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _channelType == null
                      ? null
                      : () {
                          if (_channelType == AmityChannelType.CONVERSATION &&
                              _userIdsEditController.text.trim().isEmpty) {
                            CommonSnackbar.showNagativeSnackbar(
                                context, 'Error', 'Please enter userId for conversation channel');
                            return;
                          }
                          ProgressDialog.show(context, asyncFunction: _createChannel).then((value) {
                            GoRouter.of(context).pop();
                          }).onError((error, stackTrace) {
                            ErrorDialog.show(context, title: 'Error', message: error.toString());
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

  Future _createChannel() async {
    AmityImage? communityAvatar;
    if (_avatar != null) {
      AmityUploadResult<AmityImage> amityUploadResult = await AmityCoreClient.newFileRepository()
          .uploadImage(File(_avatar!.path))
          .stream
          .firstWhere((element) => element is AmityUploadComplete);
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        communityAvatar = amityUploadComplete.getFile as AmityImage;
        // _images.add(amityUploadComplete.getFile as AmityImage);
      }
    }

    String channeld = _channelIdEditController.text.trim();
    String name = _nameEditController.text.trim();

    final metadataString = _metadataEditController.text.trim();
    Map<String, dynamic> metadata = {};
    try {
      metadata = jsonDecode(metadataString);
    } catch (e) {
      print('metadata decode failed');
    }

    List<String> userIds = [];
    if (_userIdsEditController.text.isNotEmpty) {
      userIds = _userIdsEditController.text.trim().split(',').map((e) => e.trim()).toList();
    }

    ChannelCreatorBuilder? builder;
    switch (_channelType) {
      case AmityChannelType.CONVERSATION:
        if (userIds.isEmpty) {
          CommonSnackbar.showNagativeSnackbar(context, 'Error', 'Please enter userId for conversation channel');
          return;
        }

        builder = AmityChatClient.newChannelRepository().createChannel().conversationType().withUserIds(userIds);

        if (channeld.isEmpty) channeld = const Uuid().v4();
        builder.channelId(channeld);

        break;
      case AmityChannelType.COMMUNITY:
        if (channeld.isNotEmpty) {
          builder = AmityChatClient.newChannelRepository().createChannel().communityType().withChannelId(channeld);
        } else {
          builder = AmityChatClient.newChannelRepository().createChannel().communityType().withDisplayName(name);

          // if (channeld.isEmpty) channeld = const Uuid().v4();
          builder.channelId(channeld);
        }
        break;
      case AmityChannelType.LIVE:
        if (channeld.isNotEmpty) {
          builder = AmityChatClient.newChannelRepository().createChannel().liveType().withChannelId(channeld);
        } else {
          builder = AmityChatClient.newChannelRepository().createChannel().liveType().withDisplayName(name);
          if (channeld.isEmpty) channeld = const Uuid().v4();
          builder.channelId(channeld);
        }

        break;
      default:
    }

    builder!.userIds(userIds);
    builder.displayName(name);

    if (communityAvatar != null) builder.avatar(communityAvatar);

    if (metadata.isNotEmpty) builder.metadata(metadata);

    if (_tagsEditController.text.isNotEmpty) {
      builder.tags(_tagsEditController.text.trim().split(','));
    }

    await builder.create();
  }
}
