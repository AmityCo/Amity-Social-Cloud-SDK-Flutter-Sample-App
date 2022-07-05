import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowWithdrawRequest {
  /* begin_sample_code
    gist_id: b3eaaf0b91c83b5b3f1fde3f90a52fde
    filename: AmityFollowWithdrawRequest.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter withdraw follow request info example
    */
  void withdrawFollowRequest(String userId) {
    AmityCoreClient.newUserRepository()
        .relationship()
        .me()
        .unfollow(userId = userId)
        .then((value) => {
          //success
        })
        .onError((error, stackTrace) => {
          //handle error
        }); 
  }
    /* end_sample_code */
}
