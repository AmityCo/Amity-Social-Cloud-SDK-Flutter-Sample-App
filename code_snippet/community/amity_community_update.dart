import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityUpdate {
  /* begin_sample_code
    gist_id: 36e108c4787f70882408276a55756f4c
    filename: AmityCommunityUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update community example
    */
  void updateCommunity(String communityId, AmityImage updatingAvatar) {
    AmitySocialClient.newCommunityRepository()
        .updateCommunity(communityId)
        .avatar(updatingAvatar)
        .displayName('updated name')
        .description('updated description')
        .isPublic(false)
        .isPostReviewEnabled(false)
        .metadata({'updateKey': 'updateValue'})
        .update()
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
