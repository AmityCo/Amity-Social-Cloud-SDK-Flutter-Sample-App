import 'dart:convert';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';
import 'package:go_router/go_router.dart';

class CommunityUpdateScreen extends StatefulWidget {
  CommunityUpdateScreen({Key? key, required this.communityId})
      : super(key: key);
  final String communityId;

  @override
  State<CommunityUpdateScreen> createState() => _CommunityUpdateScreenState();
}

class _CommunityUpdateScreenState extends State<CommunityUpdateScreen> {
  final _formState = GlobalKey<FormState>();

  final _nameEditController = TextEditingController();
  final _desEditController = TextEditingController();
  final _catsEditController = TextEditingController();
  final _userIdsEditController = TextEditingController();
  final _metadataEditController = TextEditingController();

  bool _isPublic = false;
  bool _isPostReviewEnable = false;

  // bool setValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AmitySocialClient.newCommunityRepository()
        .getCommunity(widget.communityId)
        .then((value) {
      setState(() {
        _nameEditController.text = value.displayName!;
        _desEditController.text = value.description!;

        _isPublic = value.isPublic!;

        _catsEditController.text = value.categories!.join(',');
      });
    }).onError((error, stackTrace) {
      ErrorDialog.show(context, title: 'Error', message: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Community'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formState,
          child: Column(
            children: [
              TextFormField(
                controller: _nameEditController,
                decoration:
                    const InputDecoration(hintText: 'Enter Community Name'),
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
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: _catsEditController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Enter Comma seperated Category Ids',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _metadataEditController,
                decoration:
                    const InputDecoration(hintText: 'Enter Community metadata'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ProgressDialog.show(context, asyncFunction: _updateCommunity)
                      .then((value) {
                    GoRouter.of(context).pop();
                  }).onError((error, stackTrace) {
                    ErrorDialog.show(context,
                        title: 'Error', message: error.toString());
                  });
                },
                child: const Text('Update Community'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _updateCommunity() async {
    String name = _nameEditController.text.trim();
    String des = _desEditController.text.trim();

    final _metadataString = _metadataEditController.text.trim();
    Map<String, dynamic> _metadata = {};
    try {
      _metadata = jsonDecode(_metadataString);
    } catch (e) {
      print('metadata decode failed');
    }

    final communityCreator = AmitySocialClient.newCommunityRepository()
        .updateCommunity(widget.communityId)
        .displayName(name)
        .description(des)
        .metadata(_metadata)
        .isPublic(_isPublic)
        .isPostReviewEnabled(_isPostReviewEnable);

    if (_catsEditController.text.isNotEmpty) {
      communityCreator.categoryIds(_catsEditController.text.trim().split(','));
    }

    // if (_userIdsEditController.text.isNotEmpty) {
    //   communityCreator.userIds(_userIdsEditController.text.trim().split(','));
    // }

    await communityCreator.update();
  }
}
