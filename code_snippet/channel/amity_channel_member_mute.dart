import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberMute {
  /* begin_sample_code
    gist_id: e8c60cf97a6b829ee31a00629fc973c4
    filename: AmityChannelMemberMute.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter mute channel member example
    */
  void muteChannelUsers() {
    final userIds = List.of(['user1', 'user2']);
    AmityChatClient.newChannelRepository()
        .moderation('channelId')
        .muteMembers(userIds)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
