import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionMessageQuery {
  /* begin_sample_code
    gist_id: 11ebb4a6083bdf6cef7d8a6c4cc06c49
    filename: AmityReactionMessageQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query reaction in message example
    */
  final amityReactions = <AmityReaction>[];
  late PagingController<AmityReaction> _reactionController;

  void queryMessageReaction(String messageId) {
    _reactionController = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getReaction(messageId: messageId)
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
