import 'package:amity_sdk/amity_sdk.dart';

class AmityPostGet {
  /* begin_sample_code
    gist_id: 22dae091c9f2b14b28440f2a68233bb2
    filename: AmityPostGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post example
    */
  void getPost(String postId) {
    AmitySocialClient.newPostRepository()
        .getPost(postId)
        .then((AmityPost post) {
      //handle result
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
