import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelLeave {
  /* begin_sample_code
    gist_id: a4e129fbe74b0a9efd6e863b7c381cad
    filename: AmityChannelLeave.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter leave channel example
    */
  void leaveChannel(String channelId) {
    AmityChatClient.newChannelRepository()
        .leaveChannel(channelId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
