import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityJoin {
  /* begin_sample_code
    gist_id: f60a5504a5be1b390bc125f515444fc9
    filename: AmityCommunityJoin.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter join community example
    */
  void joinCommunity(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .joinCommunity(communityId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
