import 'package:amity_sdk/amity_sdk.dart';

class AmityPollDelete {
  /* begin_sample_code
    gist_id: 62460daf28e4107b6f35188b1893de1c
    filename: AmityPollDelete.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter delete poll example
    */
  void deletePoll() {
    AmitySocialClient.newPollRepository()
        .deletePoll(pollId: 'pollId')
        .then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
