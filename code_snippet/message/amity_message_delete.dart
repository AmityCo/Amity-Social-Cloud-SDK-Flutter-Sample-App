import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageDelete {
  /* begin_sample_code
    gist_id: 252bf750d3803761412412d7e10f3bda
    filename: AmityMessageDelete.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message delete example
    */

  void deleteMessage() {
    // update delete
    AmityChatClient.newMessageRepository().deleteMessage('deleteId').then((_) {
      //handle result
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
