import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

class AmityMessageView {
  /* begin_sample_code
    gist_id: 4027a2a8b70a49e3903abe76a9983d44
    filename: AmityMessageView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter view message example
    */
  void getMessage(String messageId) {
    AmityChatClient.newMessageRepository()
        .getMessage(messageId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  //example of using AmityMessage with StreamBuilder
  void observeMessage(AmityMessage message) {
    StreamBuilder<AmityMessage>(
        stream: message.listen.stream,
        builder: (context, snapshot) {
          // update widget
          // eg. widget.text = message.displayName
          return Container();
        });
  }

  /* end_sample_code */
}
