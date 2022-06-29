import 'package:amity_sdk/amity_sdk.dart';

class AmityPostDecline {
  /* begin_sample_code
    gist_id: 39382c68b3952ea93969da4468a9fbba
    filename: AmityPostDecline.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter decline post example
    */

  //current post collection from feed repository
  late PagingController<AmityPost> _controller;

  void declinePost(String postId) {
    AmitySocialClient.newPostRepository()
        .reviewPost(postId: postId)
        .decline()
        .then((value) {
      //success
      //optional: to remove the declined post from the current post collection
      //you will need manually remove the declined post from the collection
      //for example :
      _controller.removeWhere((element) => element.postId == postId);
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
