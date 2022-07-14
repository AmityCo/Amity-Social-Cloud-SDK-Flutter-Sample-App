import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionPostQuery {
  /* begin_sample_code
    gist_id: 4952a13a22bdb16b2adb9e289123aab6
    filename: AmityReactionPostQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query reaction in post example
    */
  final amityReactions = <AmityReaction>[];
  late PagingController<AmityReaction> _reactionController;

  void queryPostReaction(String postId) {
    _reactionController = PagingController(
      pageFuture: (token) => AmitySocialClient.newPostRepository()
          .getReaction(postId: postId)
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
