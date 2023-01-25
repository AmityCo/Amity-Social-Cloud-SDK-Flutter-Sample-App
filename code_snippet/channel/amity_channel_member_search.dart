import 'package:amity_sdk/amity_sdk.dart';

class AmityChannelMemberSearch {
  /* begin_sample_code
    gist_id: c1476d8cc7e4a698c49460440b483151
    filename: AmityChannelMemberSearch.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter search channel members example
    */
  final _amityChannelMembers = <AmityChannelMember>[];
  late PagingController<AmityChannelMember> _channelMembersController;

  void queryChannelMembers(String channelId, String keyword) {
    _channelMembersController = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .membership(channelId)
          .searchMembers(keyword)
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
