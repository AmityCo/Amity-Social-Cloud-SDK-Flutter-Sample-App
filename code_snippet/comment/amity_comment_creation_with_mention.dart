import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentCreation {
  /* begin_sample_code
    gist_id: 34836861e7d5f5c42d396ecee361c19a
    filename: AmityPostTextCreationWithMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text comment with mention example 
    */

  //current parent comment collection
  final _amityComments = <AmityComment>[];

  //create comment to a post
  void createComment(String postId) {
    const userId = 'userAId';
    const startMentionIndex = 0;
    const mentionLength = 6;
    //create AmityMentionMetadata from userId, startIndex and length
    final mentionMetadata = AmityUserMentionMetadata(
        userId: userId, index: startMentionIndex, length: mentionLength);
    //construct AmityMentionMetadata to JsonObject using AmityMentionMetadataCreator
    final mentionMetadataCreator =
        AmityMentionMetadataCreator([mentionMetadata]).create();

    AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .create()
        .text('Comment from Brian!')
        //mentionUsers to trigger push notifications
        .mentionUsers([userId])
        //metadata to render mention highlights
        .metadata(mentionMetadataCreator)
        .send()
        .then((AmityComment comment) => {
              //handle result
              //optional: to present the created comment in to the current replied comment collection
              //you will need manually put the newly created comment in to the collection
              //for example :
              _amityComments.add(comment)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  //current replied comment collection
  final _amityRepliedComments = <AmityComment>[];

  //create comment as a reply comment to parent comment in a postnt
  void replyComment(String postId, String commentParentId) {
    const userId = 'userAId';
    const startMentionIndex = 0;
    const mentionLength = 6;
    //create AmityMentionMetadata from userId, startIndex and length
    final mentionMetadata = AmityUserMentionMetadata(
        userId: userId, index: startMentionIndex, length: mentionLength);
    //construct AmityMentionMetadata to JsonObject using AmityMentionMetadataCreator
    final mentionMetadataCreator =
        AmityMentionMetadataCreator([mentionMetadata]).create();

    AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .parentId(commentParentId)
        .create()
        .text('Reply to Brian`s comment')
        //mentionUsers to trigger push notifications
        .mentionUsers([userId])
        //metadata to render mention highlights
        .metadata(mentionMetadataCreator)
        .send()
        .then((AmityComment comment) => {
              //handle result
              //handle result
              //optional: to present the replied comment in to the current replied comment collection
              //you will need manually put the newly replied comment in to the collection
              //for example :
              _amityRepliedComments.add(comment)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
