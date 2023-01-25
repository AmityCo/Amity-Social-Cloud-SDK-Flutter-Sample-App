import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageMentionViewHelperRender {
  /* begin_sample_code
    gist_id: 4b4e228de1dd068612d462006eba80ec
    filename: AmityMessageMentionViewHelperRender.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message user and channel mention rendering with helper
    */
  void renderTextMessageWithUserMention(AmityMessage message) {
    // parse metadata with the helper
    final mentionedGetter =
        AmityMentionMetadataGetter(metadata: message.metadata!);
    final mentionedUsers = mentionedGetter.getMentionedUsers();
    final mentionedChannels = mentionedGetter.getMentionedChannels();

    for (var mentionedUser in mentionedUsers) {
      // get started index of mentioned user
      mentionedUser.index;
      // get length of mentioned user
      mentionedUser.length;
    }

    for (var mentionedChannel in mentionedChannels) {
      // get started index of mentioned channel
      mentionedChannel.index;
      // get length of mentioned channel
      mentionedChannel.length;
    }
  }
  /* end_sample_code */
}
