import 'package:amity_sdk/amity_sdk.dart';

class AmityPostApprove {
  /* begin_sample_code
    gist_id: 0d54863b170b11f7def61d0484ff2e69
    filename: AmityPostApprove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter approve post example
    */

  //current post collection from feed repository
  late PagingController<AmityPost> _controller;

  void approvePost(String postId) {
    AmitySocialClient.newPostRepository()
        .reviewPost(postId: postId)
        .approve()
        .then((value) {
      //success
      //optional: to remove the approved post from the current post collection
      //you will need manually remove the approved post from the collection
      //for example :
      _controller.removeWhere((element) => element.postId == postId);
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
