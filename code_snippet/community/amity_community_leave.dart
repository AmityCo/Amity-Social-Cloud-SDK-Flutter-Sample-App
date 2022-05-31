import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityLeave {
  /* begin_sample_code
    gist_id: 2327681b1e0674e477fe1967bdbbaa57
    filename: AmityCommunityLeave.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter leave community example
    */
  void joinCommunity(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .leaveCommunity(communityId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
