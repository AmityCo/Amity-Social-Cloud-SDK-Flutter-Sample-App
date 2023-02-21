import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:go_router/go_router.dart';

class MessageUpdateScreen extends StatelessWidget {
  MessageUpdateScreen({Key? key, required this.messageId}) : super(key: key);
  final String messageId;

  final _formState = GlobalKey<FormState>();
  final _textEditController = TextEditingController();
  final _metadataEditController = TextEditingController();
  final _tagsEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Message - $messageId'),
      ),
      body: FutureBuilder<AmityMessage>(
          future: AmityChatClient.newMessageRepository().getMessage(messageId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final value = snapshot.data!;

            if (value.data is MessageTextData) {
              _textEditController.text =
                  (value.data as MessageTextData).text ?? '';
            }

            if (value.metadata != null) {
              _metadataEditController.text = value.metadata?.toString() ?? '';
            }

            if (value.amityTags != null) {
              _tagsEditController.text = value.amityTags?.tags?.join(',') ?? '';
            }

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formState,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _textEditController,
                        decoration: const InputDecoration(hintText: 'Text'),
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
                        decoration: const InputDecoration(hintText: 'Metadata'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          ProgressDialog.show(
                            context,
                            asyncFunction: () => _updateMessage(value),
                          ).then((value) {
                            GoRouter.of(context).pop();
                          }).onError((error, stackTrace) {
                            ErrorDialog.show(context,
                                title: 'Error', message: error.toString());
                          });
                        },
                        child: const Text('Update Message'),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future _updateMessage(AmityMessage message) async {
    final builder = message.upate();

    String text = _textEditController.text.trim();
    if (text.isNotEmpty) {
      builder.text(text);
    }

    final _metadataString = _metadataEditController.text.trim();
    if (_metadataString.isNotEmpty) {
      builder.text(text);
    }

    if (_tagsEditController.text.isNotEmpty) {
      builder.tags(_tagsEditController.text.trim().split(','));
    }

    await builder.update();
  }
}
