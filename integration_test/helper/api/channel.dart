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
  Future createLiveChannel(channelId, displayName) async {
    AmityChatClient.newChannelRepository()
        .createChannel()
        .liveType()
        .withChannelId(channelId)
        .displayName(displayName)
        .create();
  }
  Future createConversationChannel(userId, displayName) async {
    AmityChatClient.newChannelRepository()
        .createChannel()
        .conversationType()
        .withUserId(userId)
        .displayName(displayName)
        .create();
  }

}