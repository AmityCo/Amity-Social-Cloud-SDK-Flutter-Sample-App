import 'package:amity_sdk/amity_sdk.dart';

class ChannelAPI {
  Future createCommunityChannel(channelId, displayName) async {
    await AmityChatClient.newChannelRepository()
        .createChannel()
        .communityType()
        .withChannelId(channelId)
        .displayName(displayName) //Optional
        .create();
  }
}