import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityRemoveRole {
  /* begin_sample_code
    gist_id: 7ccfbb26c717e9be0af8a771e6f5ceae
    filename: AmityCommunityRemoveRole.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove community role example
    */
  void removeRole(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityId)
        .removeRole('community-moderator', ['userId1', 'userId2'])
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
