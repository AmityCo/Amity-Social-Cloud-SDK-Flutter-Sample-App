import 'package:amity_sdk/amity_sdk.dart';

class AmityMyFollowInfo {
  /* begin_sample_code
    gist_id: 52225809dae070188a0278c8bee9969c
    filename: AmityMyFollowCount.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter my follow info example
    */
  void getFollowInfo() {
    AmityCoreClient.newUserRepository()
        .relationship()
        .me()
        .getFollowInfo()
        .then((myFollowInfo) => {
              //my follower count
              myFollowInfo.followerCount,
              //my following count
              myFollowInfo.followingCount
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
