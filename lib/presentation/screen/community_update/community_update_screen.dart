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

  bool setValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Community'),
      ),
      body: FutureBuilder<AmityCommunity>(
        future: AmitySocialClient.newCommunityRepository()
            .getCommunity(widget.communityId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!setValue) {
              setValue = !setValue;
              _nameEditController.text = snapshot.data!.displayName!;
              _desEditController.text = snapshot.data!.description!;
              _isPublic = snapshot.data!.isPublic!;
              _catsEditController.text = snapshot.data!.categories!.join(',');
              if (snapshot.data?.metadata != null) {
                _metadataEditController.text =
                    snapshot.data!.metadata.toString();
              }
            }

            return Container(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formState,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameEditController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Community Name'),
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
                        _isPublic = value!;
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
                    TextFormField(
                      controller: _metadataEditController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Community metadata'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ProgressDialog.show(context,
                                asyncFunction: _updateCommunity)
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
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future _updateCommunity() async {
    String name = _nameEditController.text.trim();
    String des = _desEditController.text.trim();

    final communityCreator = AmitySocialClient.newCommunityRepository()
        .updateCommunity(widget.communityId)
        .displayName(name)
        .description(des)
        .isPublic(_isPublic);

    if (_catsEditController.text.isNotEmpty) {
      communityCreator.categoryIds(_catsEditController.text.trim().split(','));
    }

    // if (_userIdsEditController.text.isNotEmpty) {
    //   communityCreator.userIds(_userIdsEditController.text.trim().split(','));
    // }

    await communityCreator.update();
  }
}
