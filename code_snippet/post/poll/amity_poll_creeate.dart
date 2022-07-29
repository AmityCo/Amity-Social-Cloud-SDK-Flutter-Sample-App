import 'package:amity_sdk/amity_sdk.dart';

class AmityPollCreate {
  /* begin_sample_code
    gist_id: 7ad2ce65b2a60bf8117ba323093087d7
    filename: AmityPollCreate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create poll example
    */

  void createPollPost(String postId) async {
    //create a poll as the first step
    final amityPoll = await AmitySocialClient.newPollRepository()
        .createPoll(question: 'What are your favorite songs?')
        .answers(answers: [
          AmityPollAnswer.text('First date'),
          AmityPollAnswer.text('All of the small things'),
          AmityPollAnswer.text('The rock show'),
        ])
        .answerType(
            //available answer types are: AmityPollAnswerType.SINGLE and AmityPollAnswerType.MULTIPLE
            answerType: AmityPollAnswerType.MULTIPLE)
        .closedIn(
            closedIn: Duration(
                milliseconds: const Duration(minutes: 45)
                    .inMilliseconds)) //open for 45 mins
        .create();

    //after the poll is created, we are now able to create a poll post
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetCommunity('communityId')
        .poll(amityPoll.pollId!) //use pollId from the created poll above
        .text(amityPoll
            .question!) //use poll's question from the created poll above
        .post()
        .then((AmityPost createdPost) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
