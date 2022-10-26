import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberQuery {
  /* begin_sample_code
    gist_id: 7a99316096dcc949cbffd4b09f49c869
    filename: AmityChannelMemberQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query channel members example
    */
  final _amityChannelMembers = <AmityChannelMember>[];
  late PagingController<AmityChannelMember> _channelMembersController;

  void queryChannelMembers(String channelId) {
    _channelMembersController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .membership(channelId)
          .getMembers()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_channelMembersController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityChannelMembers.clear();
            _amityChannelMembers.addAll(_channelMembersController.loadedItems);
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
