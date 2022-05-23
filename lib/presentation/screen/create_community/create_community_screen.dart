import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';
import 'package:go_router/go_router.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({Key? key}) : super(key: key);

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _formState = GlobalKey<FormState>();

  final _nameEditController = TextEditingController();
  final _desEditController = TextEditingController();
  final _catsEditController = TextEditingController();
  final _userIdsEditController = TextEditingController();

  bool _isPublic = false;

  @override
  Widget build(BuildContext context) {
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
                ElevatedButton(
                  onPressed: () {
                    ProgressDialog.show(context,
                            asyncFunction: _createCommunity)
                        .then((value) {
                      GoRouter.of(context).pop();
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
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
    String name = _nameEditController.text.trim();
    String des = _desEditController.text.trim();

    final communityCreator = AmitySocialClient.newCommunityRepository()
        .createCommunity(name)
        .description(des)
        .isPublic(_isPublic);

    if (_catsEditController.text.isNotEmpty) {
      communityCreator.categoryIds(_catsEditController.text.trim().split(','));
    }

    if (_userIdsEditController.text.isNotEmpty) {
      communityCreator.userIds(_userIdsEditController.text.trim().split(','));
    }

    await communityCreator.create();
  }
}
