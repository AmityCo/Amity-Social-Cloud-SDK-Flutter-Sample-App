import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelQuery {
  /* begin_sample_code
    gist_id: 009393e93159effa667638bcb48d2884
    filename: AmityChannelQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query channels example
    */
  final _amitychannel = <AmityChannel>[];
  late PagingController<AmityChannel> _channelController;

  // Available Channel Type options
  // AmityChannelType.COMMUNITY;
  // AmityChannelType.LIVE;
  // AmityChannelType.BROADCAST;
  // AmityChannelType.CONVERSATION;

  void queryChannel() {
    // Query for Community type
    _channelController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .communityType()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitychannel.clear();
            _amitychannel.addAll(_channelController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );

    // Query for Live type
    _channelController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .liveType()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitychannel.clear();
            _amitychannel.addAll(_channelController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );

    // Query for Broadcast type
    _channelController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .broadcastType()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitychannel.clear();
            _amitychannel.addAll(_channelController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );

    // Query for Conversation type
    _channelController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .conversationType()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitychannel.clear();
            _amitychannel.addAll(_channelController.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );

    // Query for Multiple types
    final types = <AmityChannelType>[
      AmityChannelType.LIVE,
      AmityChannelType.COMMUNITY
    ];
    _channelController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .types(types)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amitychannel.clear();
            _amitychannel.addAll(_channelController.loadedItems);
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
