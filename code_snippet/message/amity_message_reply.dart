import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageReply {
  /* begin_sample_code
    gist_id: 252bf750d3803761412412d7e10f3bda
    filename: AmityMessageReply.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message reply example
    */

  void replyMessage() {
    // Reply message
    AmityChatClient.newMessageRepository()
        .createMessage('channelId')
        .parentId('parentMessageId')
        .text("What's up Social Cloud!!")
        .send()
        .then((_) {
      //handle result
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
