import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberUnBan {
  /* begin_sample_code
    gist_id: 58b07bb02f6cc142f5ab21237cebb4ba
    filename: AmityCommunityMemberBan.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unban community membr example
    */
  void unbanMember(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityId)
        .unbanMember(['userId1', 'userId2'])
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
