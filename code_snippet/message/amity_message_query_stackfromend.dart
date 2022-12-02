import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageQueryStackFromEnd {
  /* begin_sample_code
    gist_id: 27eb6533278ff147baf24517d9c7ff70
    filename: AmityMessageQueryStackFromEnd.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query stackfromend messages example
    */
  final _amitymessages = <AmityMessage>[];
  late PagingController<AmityMessage> _messageController;

  void queryMessage() {
    // Query for Message
    _messageController = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getMessages('channelId')
          .stackFromEnd(true)
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
