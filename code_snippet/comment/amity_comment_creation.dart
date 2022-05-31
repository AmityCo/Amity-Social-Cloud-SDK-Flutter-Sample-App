import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentCreation {
  /* begin_sample_code
    gist_id: 99d02516b7f851d06100cfcfe9e3e177
    filename: AmityPostTextCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create text comment example
    */

  //current parent comment collection
  final _amityComments = <AmityComment>[];

  //create comment to a post
  void createComment(String postId) {
    AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .create()
        .text('Comment from Brian!')
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
    AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .parentId(commentParentId)
        .create()
        .text('Reply to Brian`s comment')
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
