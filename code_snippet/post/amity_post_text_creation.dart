import 'package:amity_sdk/amity_sdk.dart';

class AmityPostTextCreation {
  /* begin_sample_code
    gist_id: b6a8745dbe9977fb6e52c4afe3caa537
    filename: AmityPostTextCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text post example
    */
  void createTextPost() {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(
            'userId') // or targetMe(), targetCommunity(communityId: String)
        .text('Hello from flutter!')
        .post()
        .then((AmityPost post) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
