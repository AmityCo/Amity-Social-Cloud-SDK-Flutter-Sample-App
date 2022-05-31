import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityAddRole {
  /* begin_sample_code
    gist_id: fdcbc7e3baaf14159c1051903869df15
    filename: AmityCommunityAddRole.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add community role example
    */
  void addRole(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityId)
        .addRole('community-moderator', ['userId1', 'userId2'])
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
