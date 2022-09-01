import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageTextCreate {
  /* begin_sample_code
    gist_id: cdfb7544aea37943da47bf688266ce6d
    filename: AmityMessageTextCreate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text message example
    */
  void createMessage(String channelId) {
    AmityChatClient.newMessageRepository()
        .createMessage(channelId)
        .text('Hello from flutter :D')
        .send()
        .then((value) {
      //handle result
      //message has been sent successfully
    }).onError((error, stackTrace) {
      //handle error
    });
    /* end_sample_code */
  }
}
