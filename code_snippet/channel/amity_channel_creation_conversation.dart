import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelCreationConversation {
  /* begin_sample_code
    gist_id: 35ae79e4b9f153098ef58a469e0b012b
    filename: AmityChannelCreationConversation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create conversation channel example
    */

  void createConversationChannel() {
    // create channel and let SDK handle channelId generation
    AmityChatClient.newChannelRepository()
        .createChannel()
        .conversationType()
        .withUserId('myFriendId')
        .displayName('Chat with my BFF') //Optional
        .metadata({'key': 'value'}) //Optional
        .tags(['friends', 'New Arrival']) //Optional
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
