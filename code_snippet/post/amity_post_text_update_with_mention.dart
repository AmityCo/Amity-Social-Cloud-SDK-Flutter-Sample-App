import 'package:amity_sdk/amity_sdk.dart';

class AmityPostTextUpdateWithMention {
  /* begin_sample_code
    gist_id: 5e1cc562ec788a51117a7fc4f04ea14d
    filename: AmityPostTextUpdateWithMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update text post with mention example
    */

  void updateTextPostWithMention(AmityPost post) {
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
    post
        .edit()
        .text('updated post content')
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
