import 'package:amity_sdk/amity_sdk.dart';

class AmityPostDelete {
  /* begin_sample_code
    gist_id: c41cec566872b8b4f636e4aa6673e0cd
    filename: AmityPostDelete.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post example
    */

  //current post collection from feed repository
  final _amityPosts = <AmityPost>[];

  void deletePost(String postId) {
    AmitySocialClient.newPostRepository()
        .deletePost(postId: postId)
        .then((value) {
      //success
      //optional: to remove the deleted post from the current post collection
      //you will need manually remove the deleted post from the collection
      //for example :
      _amityPosts.removeWhere((element) => element.postId == postId);
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
