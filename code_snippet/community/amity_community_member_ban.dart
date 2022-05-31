import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberBan {
  /* begin_sample_code
    gist_id: dc37764acf5e623db07c1846814102f7
    filename: AmityCommunityMemberBan.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter ban community membr example
    */
  void banMember(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityId)
        .banMember(['userId1', 'userId2'])
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
