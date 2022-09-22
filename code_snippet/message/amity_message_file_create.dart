import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageFileCreate {
  /* begin_sample_code
    gist_id: 5b0640112b6939c9435164ef144bc27c
    filename: AmityMessageFileCreate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create file message example
    */
  void createFileMessage(String channelId, Uri fileUri) {
    AmityChatClient.newMessageRepository()
        .createMessage(channelId)
        .file(fileUri)
        .caption('file caption')
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
