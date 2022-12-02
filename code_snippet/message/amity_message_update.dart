import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageUpdate {
  /* begin_sample_code
    gist_id: b7b6661f0df6798b8ab3715ba756b2e6
    filename: AmityMessageUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update message example
    */

  void updateMessage() {
    // update message
    AmityChatClient.newMessageRepository()
        .updateMessage('channelId', 'messageId')
        .text('updated message')
        .tags(['tag1', 'tag2'])
        .metadata({'key': 'value'})
        .update()
        .then((AmityMessage message) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
