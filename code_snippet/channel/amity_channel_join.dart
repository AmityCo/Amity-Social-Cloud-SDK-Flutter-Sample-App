import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelJoin {
  /* begin_sample_code
    gist_id: 1e92fcd7e40deb3c1fa3e672172231f8
    filename: AmityChannelJoin.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter join channel example
    */
  void joinChannel(String channelId) {
    AmityChatClient.newChannelRepository()
        .joinChannel(channelId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
