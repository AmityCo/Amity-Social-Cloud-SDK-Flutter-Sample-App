import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentQuery {
  /* begin_sample_code
    gist_id: 5c680bbc0f6a10357ed589fcd6cd3534
    filename: AmityCommentQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query comments example
    */
  final amityComments = <AmityComment>[];
  late PagingController<AmityComment> _commentController;

  // To query for all first level comments without parentId
  void queryComments(String postId) {
    _commentController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(postId)
          .includeDeleted(true) //optional
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_commentController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityComments.clear();
            amityComments.addAll(_commentController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );
  }

  final amityRepliedComments = <AmityComment>[];
  late PagingController<AmityComment> _repliedCommentController;

  // To query for replies on a comment, pass the commentId as a parentId
  void queryRepliedComments(String postId, String commentParentId) {
    _repliedCommentController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(postId)
          .parentId(commentParentId)
          .includeDeleted(true) //optional
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_repliedCommentController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityComments.clear();
            amityComments.addAll(_repliedCommentController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );
  }
  /* end_sample_code */
}
