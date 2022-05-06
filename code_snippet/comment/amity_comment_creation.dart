import 'package:amity_sdk/lib.dart';
import 'package:amity_sdk/public/client/amity_social_client.dart';

class AmityCommentCreation {
  /* begin_sample_code
    gist_id: e3cc59ddc053416faea5b996c7b4d612
    filename: AmityPostTextCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text comment example
    */
  void createComment(String postId) {
    AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .create()
        .text('Comment from Brian!')
        .send()
        .then((AmityComment comment) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
