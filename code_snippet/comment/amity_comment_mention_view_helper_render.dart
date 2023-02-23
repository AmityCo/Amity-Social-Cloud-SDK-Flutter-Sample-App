import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentMentionViewHelperRender {
  /* begin_sample_code
    gist_id: a6801145f042d65de89b2cde3042931e
    filename: AmityCommentMentionViewHelperRender.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter comment user mention rendering with helper
    */
  void renderTextPostWithUserMention(AmityComment comment) {
    // parse metadata with the helper
    final mentionedGetter =
        AmityMentionMetadataGetter(metadata: comment.metadata!);
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
