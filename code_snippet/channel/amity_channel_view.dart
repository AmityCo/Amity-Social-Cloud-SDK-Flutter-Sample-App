import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

class AmityChannelView {
  /* begin_sample_code
    gist_id: 358169d6acb5e4def7ee6b6c1d3ba5df
    filename: AmityChannelView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter view channel example
    */
  void getChannel(String channelId) {
    AmityChatClient.newChannelRepository()
        .getChannel(channelId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  //example of using AmityChannel with StreamBuilder
  void observeChannel(AmityChannel channel) {
    StreamBuilder<AmityChannel>(
        stream: channel.listen.stream,
        builder: (context, snapshot) {
          // update widget
          // eg. widget.text = channel.displayName
          return Container();
        });
  }

  /* end_sample_code */
}
