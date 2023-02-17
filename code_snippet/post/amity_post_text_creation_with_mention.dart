import 'package:amity_sdk/amity_sdk.dart';

class AmityPostTextCreation {
  /* begin_sample_code
    gist_id: 859934e8745bc50d05e4946aa8b36064
    filename: AmityPostTextCreationWithMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text post with mention example
    */

  //current post collection from feed repository
  late PagingController<AmityPost> _controller;

  void createTextPostWithMention() {
    const userId = 'userAId';
    const startMentionIndex = 0;
    const mentionLength = 6;
    //create AmityMentionMetadata from userId, startIndex and length
    final mentionMetadata = AmityUserMentionMetadata(
        userId: userId, index: startMentionIndex, length: mentionLength);
    //construct AmityMentionMetadata to JsonObject using AmityMentionMetadataCreator
    final mentionMetadataCreator =
        AmityMentionMetadataCreator([mentionMetadata]).create();

    //create a text post with mention
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(
            'userId') // or targetMe(), targetCommunity(communityId: String)
        .text('Hello from flutter!')
        //mentionUsers to trigger push notifications
        .mentionUsers([userId])
        //metadata to render mention highlights
        .metadata(mentionMetadataCreator)
        .post()
        .then((AmityPost post) => {
              //handle result
              //optional: to present the created post in to the current post collection
              //you will need manually put the newly created post in to the collection
              //for example :
              _controller.add(post)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
