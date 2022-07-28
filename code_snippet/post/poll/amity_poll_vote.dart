import 'package:amity_sdk/amity_sdk.dart';

class AmityPollVote {
  /* begin_sample_code
    gist_id: 3d8b0d27f79c4742dec10ef781d622fb
    filename: AmityPollVote.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter vote poll example
    */
  void votePoll() {
    AmitySocialClient.newPollRepository().vote(
        pollId: 'pollId', answerIds: ['answerId1', 'answerId2']).then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
