import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberUnmute {
  /* begin_sample_code
    gist_id: c55a0475dc1537b24237b2a9845eeb24
    filename: AmityChannelMemberUnmute.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unmute channel member example
    */
  void unmuteChannelUsers() {
    final userIds = List.of(['user1', 'user2']);
    AmityChatClient.newChannelRepository()
        .moderation('channelId')
        .unmuteMembers(userIds)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
