import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageMentionChannel {
  /* begin_sample_code
    gist_id: 1ad6da7f00c2899359014cdcd8ad7582
    filename: AmityMessageMentionChannel.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message channel mention
    */
  void createTextMessageWithChannelMention() {
    // mention to the whole channel

    AmityChatClient.newMessageRepository()
        .createMessage('channelId')
        .text('hi @sorbh, do you have a second?')
        .metadata(
            <String, dynamic>{}) //flexible data structure for highlighting text
        .mentionChannel()
        .send()
        .then((value) {
          //handle result
          //message has been sent successfully
        })
        .onError((error, stackTrace) {
          //handle error
        });
  }
  /* end_sample_code */
}
