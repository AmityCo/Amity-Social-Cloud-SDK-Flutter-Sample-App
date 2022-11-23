import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelUpdateMetadata {
  /* begin_sample_code
    gist_id: 7c54415183382eca370d26999460c2ba
    filename: AmityChannelUpdateMetadata.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update channel metadata example
    */

  void updateChannelMetadata() {
    // update channel metadata
    final metadata = {'tutorial_url': 'https://docs.amity.technology/'};
    AmityChatClient.newChannelRepository()
        .updateChannel('channelId')
        .metadata(metadata)
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
