import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageQuery {
  /* begin_sample_code
    gist_id: 74613ba3bd50430fd9eb687a0a2b8d59
    filename: AmityMessageQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query messages example
    */
  final _amitymessages = <AmityMessage>[];
  late PagingController<AmityMessage> _messageController;

  void queryMessage() {
    // Query for Message
    _messageController = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getMessages('channelId')
          .includeDeleted(false) //optional, default false
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_messageController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitymessages.clear();
            _amitymessages.addAll(_messageController.loadedItems);
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
