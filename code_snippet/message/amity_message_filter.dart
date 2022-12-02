import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageFilter {
  /* begin_sample_code
    gist_id: dafe0c5ec4c65e321054d058ce3710fa
    filename: AmityMessageFilter.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter filter messages example
    */
  final _amitymessage = <AmityMessage>[];
  late PagingController<AmityMessage> _messageController;

  // Available Message Type options
  // AmityMessageDataType.TEXT;
  // AmityMessageType.IMAGE;
  // AmityMessageType.FILE;
  // AmityMessageType.AUDIO;
  // AmityMessageType.CUSTOM;

  void filterMessages() {
    // data type
    const dataType = AmityMessageDataType.TEXT;

    //including tags
    var includingTags = <String>[];
    includingTags.add("games");

    //excluding tags
    var excludingTags = <String>[];
    excludingTags.add("staff-only");

    //parent messageId
    const parentId = "m50219a";

    // Query for message type
    _messageController = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getMessages('channelId')
          .parentId(parentId)
          .type(dataType)
          .includingTags(includingTags)
          .excludingTags(excludingTags)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_messageController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitymessage.clear();
            _amitymessage.addAll(_messageController.loadedItems);
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
