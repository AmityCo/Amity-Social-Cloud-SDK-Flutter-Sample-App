import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberUnban {
  /* begin_sample_code
    gist_id: d342f7489dd8214e8195fbba79a0718e
    filename: AmityChannelMemberUnban.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter bunan channel member example
    */
  void unbanChannelUsers() {
    final userIds = List.of(['user1', 'user2']);
    AmityChatClient.newChannelRepository()
        .moderation('channelId')
        .unbanMembers(userIds)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
