import 'package:amity_sdk/amity_sdk.dart';

class AmityPostMentionViewHelperRender {
  /* begin_sample_code
    gist_id: 6cdc055af9e9fb575215b0746d9f1ed1
    filename: AmityPostMentionViewHelperRender.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter post user mention rendering with helper
    */
  void renderTextPostWithUserMention(AmityPost post) {
    // parse metadata with the helper
    final mentionedGetter =
        AmityMentionMetadataGetter(metadata: post.metadata!);
    final mentionedUsers = mentionedGetter.getMentionedUsers();

    for (var mentionedUser in mentionedUsers) {
      // get started index of mentioned user
      mentionedUser.index;
      // get length of mentioned user
      mentionedUser.length;
    }
  }
  /* end_sample_code */
}
