import 'package:amity_sdk/amity_sdk.dart';

class AmityPostListen {
  /* begin_sample_code
    gist_id: bd4f33e6e1af748ef6637e2601029dfd
    filename: AmityPostListen.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter listen post example
    */
  void listenPost(String postId) {
    AmitySocialClient.newPostRepository()
        .getPostStream(postId)
        .listen((AmityPost post) {
      //handle results
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
