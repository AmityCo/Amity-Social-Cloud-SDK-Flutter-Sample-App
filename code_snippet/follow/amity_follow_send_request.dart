import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowSendRequest {
  /* begin_sample_code
    gist_id: 1d8cf850e0d4f6f9099b13fa1a7f29c1
    filename: AmityFollowSendRequest.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter send follow request info example
    */
  void sendFollowRequest(String userId) {
    AmityCoreClient.newUserRepository()
        .relationship()
        .user(userId = userId)
        .follow()
        .then((AmityFollowStatus followStatus) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
