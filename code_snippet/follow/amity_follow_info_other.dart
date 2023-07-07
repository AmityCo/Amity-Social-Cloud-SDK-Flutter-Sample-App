import 'package:amity_sdk/amity_sdk.dart';

class AmityOtherFollowInfo {
  /* begin_sample_code
    gist_id: 52d2994dcef26ef71fd3e5827b601dd1
    filename: AmityOtherFollowInfo.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter other's follow info example
    */
  void getFollowInfo(String userId) {
    AmityCoreClient.newUserRepository()
        .relationship()
        .getFollowInfo(userId)
        .then((otherFollowInfo) => {
              //my follower count
              otherFollowInfo.followerCount,
              //my following count
              otherFollowInfo.followingCount
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
