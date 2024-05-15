import 'dart:convert';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_category_list/community_category_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CommunityCreateScreen extends StatefulWidget {
  const CommunityCreateScreen({
    Key? key,
    this.categoryIds = const [],
    this.userIds = const [],
  }) : super(key: key);
  final List<String>? categoryIds;
  final List<String>? userIds;
  @override
  State<CommunityCreateScreen> createState() => _CommunityCreateScreenState();
}

class _CommunityCreateScreenState extends State<CommunityCreateScreen> {
  final _formState = GlobalKey<FormState>();

  final _nameEditController = TextEditingController();
  final _desEditController = TextEditingController();
  final _catsEditController = TextEditingController();
  final _userIdsEditController = TextEditingController();
  final _metadataEditController = TextEditingController();
  final _tagsEditController = TextEditingController();

  bool _isPublic = true;
  bool _isPostReviewEnable = false;
  bool _isCommentOnStoryEnable = true;

  XFile? _avatar;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryIds != null) {
      _catsEditController.text = widget.categoryIds!.join(',');
    }

    if (widget.userIds != null) {
      _userIdsEditController.text = widget.userIds!.join(',');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formState,
            child: Column(
              children: [
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
                  controller: _nameEditController,
                  decoration: const InputDecoration(hintText: 'Enter Community Name'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: TextFormField(
                    controller: _desEditController,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter Community Description',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Make Community public'),
                ),
                CheckboxListTile(
                  value: _isPostReviewEnable,
                  onChanged: (value) {
                    setState(() {
                      _isPostReviewEnable = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Post Review Enable'),
                ),

                CheckboxListTile(
                  value: _isCommentOnStoryEnable,
                  onChanged: (value) {
                    setState(() {
                      _isCommentOnStoryEnable = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Comment on Story Enable'),
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
                SizedBox(
                  height: 80,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CommunityCategoryListScreen(
                                selectedCategoryIds: _catsEditController.text.trim().isNotEmpty
                                    ? _catsEditController.text.trim().split(',')
                                    : null);
                          }).then((value) {
                        _catsEditController.text = value;
                      });
                    },
                    child: TextFormField(
                      controller: _catsEditController,
                      expands: true,
                      maxLines: null,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter Comma seperated Category Ids',
                        isDense: true,
                      ),
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
                  decoration: const InputDecoration(hintText: 'Enter Community metadata'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ProgressDialog.show(context, asyncFunction: _createCommunity).then((value) {
                      GoRouter.of(context).pop();
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context, title: 'Error', message: error.toString());
                    });
                  },
                  child: const Text('Create Community'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _createCommunity() async {
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

    String name = _nameEditController.text.trim();
    String des = _desEditController.text.trim();
    final metadataString = _metadataEditController.text.trim();
    Map<String, dynamic> metadata = {};
    try {
      metadata = jsonDecode(metadataString);
    } catch (e) {
      print('metadata decode failed');
    }

    AmityCommunityStorySettings storySettings = AmityCommunityStorySettings();
    storySettings.allowComment = _isCommentOnStoryEnable;
    

    final communityCreator = AmitySocialClient.newCommunityRepository()
        .createCommunity(name)
        .description(des)
        .metadata(metadata)
        .isPublic(_isPublic)
        .storySettings(storySettings)
        .postSetting( _isPostReviewEnable ? AmityCommunityPostSettings.ADMIN_REVIEW_POST_REQUIRED :AmityCommunityPostSettings.ANYONE_CAN_POST );

    
    if (_catsEditController.text.isNotEmpty) {
      communityCreator.categoryIds(_catsEditController.text.trim().split(',').map((e) => e.trim()).toList());
    }
    if (_tagsEditController.text.isNotEmpty) {
      communityCreator.tags(_tagsEditController.text.trim().split(','));
    }
    if (_userIdsEditController.text.isNotEmpty) {
      communityCreator.userIds(_userIdsEditController.text.trim().split(',').map((e) => e.trim()).toList());
    }

    if (communityAvatar != null) {
      communityCreator.avatar(communityAvatar);
    }

    await communityCreator.create();
  }
}
