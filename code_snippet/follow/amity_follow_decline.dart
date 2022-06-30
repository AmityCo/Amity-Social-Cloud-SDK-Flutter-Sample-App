import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowDecline {
  /* begin_sample_code
    gist_id: fafc417086c3d98adebae550d48e7aed
    filename: AmityFollowDecline.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter decline follow request info example
    */
  void declineFollowRequest(String userId) {
    AmityCoreClient.newUserRepository()
        .relationship()
        .me()
        .decline(userId = userId)
        .then((value) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
