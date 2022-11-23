import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelUpdate {
  /* begin_sample_code
    gist_id: 5a98844e706d6af9f0147dd0a635bba4
    filename: AmityChannelUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update channel example
    */

  void updateChannel(AmityImage avatar) {
    // update channel
    AmityChatClient.newChannelRepository()
        .updateChannel('channelId')
        .displayName('New Display name')
        .avatar(avatar)
        .tags(['tag1', 'tag2'])
        .create()
        .then((AmityChannel channel) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
