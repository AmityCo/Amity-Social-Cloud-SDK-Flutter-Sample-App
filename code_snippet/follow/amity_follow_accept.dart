import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowAccept {
  /* begin_sample_code
    gist_id: 10aebb7c52424e41f2482976306c2a83
    filename: AmityFollowAccept.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter accept follow request info example
    */
  void acceptFollowRequest(String userId) {
    AmityCoreClient.newUserRepository()
        .relationship()
        .acceptMyFollower(userId = userId)
        .then((value) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
