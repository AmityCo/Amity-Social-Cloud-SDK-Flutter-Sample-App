import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberBan {
  /* begin_sample_code
    gist_id: 7991a1742a26056c1938c2a9b5b88cc8
    filename: AmityChannelMemberBan.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter ban channel member example
    */
  void banChannelUsers() {
    final userIds = List.of(['user1', 'user2']);
    AmityChatClient.newChannelRepository()
        .moderation('channelId')
        .banMembers(userIds)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
