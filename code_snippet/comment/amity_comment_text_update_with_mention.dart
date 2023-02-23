import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentTextUpdateWithMention {
  /* begin_sample_code
    gist_id: 94844f30c4d620f7d432969e83aff13e
    filename: AmityCommentTextUpdateWithMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update text comment with mention example
    */

  void updateTextComentWithMention(AmityComment comment) {
    const userId = 'userAId';
    const startMentionIndex = 0;
    const mentionLength = 6;
    //create AmityMentionMetadata from userId, startIndex and length
    final mentionMetadata = AmityUserMentionMetadata(
        userId: userId, index: startMentionIndex, length: mentionLength);
    //construct AmityMentionMetadata to JsonObject using AmityMentionMetadataCreator
    final mentionMetadataCreator =
        AmityMentionMetadataCreator([mentionMetadata]).create();

    //update a text post with mention
    comment
        .edit()
        .text('updated comment content')
        //mentionUsers to trigger push notifications
        .mentionUsers([userId])
        //metadata to render mention highlights
        .metadata(mentionMetadataCreator)
        .build()
        .update()
        .then((post) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
