import 'package:amity_sdk/amity_sdk.dart';

class AmityPostTextCreation {
  /* begin_sample_code
    gist_id: b6a8745dbe9977fb6e52c4afe3caa537
    filename: AmityPostTextCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text post example
    */

  //current post collection from feed repository
  late PagingController<AmityPost> _controller;

  void createTextPost() {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(
            'userId') // or targetMe(), targetCommunity(communityId: String)
        .text('Hello from flutter!')
        .post()
        .then((AmityPost post) => {
              //handle result
              //optional: to present the created post in to the current post collection
              //you will need manually put the newly created post in to the collection
              //for example :
              _controller.add(post)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
