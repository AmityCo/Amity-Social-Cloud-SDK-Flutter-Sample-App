import 'package:amity_sdk/amity_sdk.dart';

class AmityPollClose {
  /* begin_sample_code
    gist_id: 174927622226e41d2c8eca6f8c7053a5
    filename: AmityPollClose.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter close poll example
    */
  void closePoll() {
    AmitySocialClient.newPollRepository()
        .closePoll(pollId: 'pollId')
        .then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
