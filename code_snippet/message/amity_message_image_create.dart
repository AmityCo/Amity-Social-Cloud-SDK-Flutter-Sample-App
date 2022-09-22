import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageImageCreate {
  /* begin_sample_code
    gist_id: 828573cec6756faac2b872a978828bf9
    filename: AmityMessageImageCreate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create image message example
    */
  void createImageMessage(String channelId, Uri imageUri) {
    AmityChatClient.newMessageRepository()
        .createMessage(channelId)
        .image(imageUri)
        .caption('image caption')
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
