import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionCommentQuery {
  /* begin_sample_code
    gist_id: 960394ce8afa5c8436a18ac58dd9eaa2
    filename: AmityReactionCommentQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query reaction in comment example
    */
  final amityReactions = <AmityReaction>[];
  late PagingController<AmityReaction> _reactionController;

  void queryCommentReaction(String commentId) {
    _reactionController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getReaction(commentId: commentId)
          //Optional to query specific reaction, eg. "like"
          .reactionName('like')
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_reactionController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityReactions.clear();
            amityReactions.addAll(_reactionController.loadedItems);
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
