import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelCreationLive {
  /* begin_sample_code
    gist_id: 271c958e1f5ff915883086d38bd9740c
    filename: AmityChannelCreationLive.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create live channel example
    */

  void createLiveChannel() {
    // create channel by specifying channelId
    AmityChatClient.newChannelRepository()
        .createChannel()
        .liveType()
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
        .liveType()
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
