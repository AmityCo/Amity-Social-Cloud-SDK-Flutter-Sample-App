import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelCreationCommunity {
  /* begin_sample_code
    gist_id: 419b175b2bc54175b29d42c36c346409
    filename: AmityChannelCreationCommunity.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create community channel example
    */

  void createCommunityChannel() {
    // create channel by specifying channelId
    AmityChatClient.newChannelRepository()
        .createChannel()
        .communityType()
        .withChannelId("sorbh1234")
        .displayName('Weekly Promo') //Optional
        .metadata({'key': 'value'}) //Optional
        .tags(['Promotion', 'New Arrival']) //Optional
        .create()
        .then((AmityChannel channel) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
    // create channel and let SDK handle channelId generation
    AmityChatClient.newChannelRepository()
        .createChannel()
        .communityType()
        .withDisplayName('Weekly Promo')
        .metadata({'key': 'value'}) //Optional
        .tags(['Promotion', 'New Arrival']) //Optional
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
