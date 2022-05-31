import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberQuery {
  /* begin_sample_code
    gist_id: 2acaf97737c3b32c7e8889c637958c99
    filename: AmityCommunityMemberQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query community members example
    */
  final _amityCommunityMembers = <AmityCommunityMember>[];
  late PagingController<AmityCommunityMember> _communityMembersController;

  //Available sort options
  // AmityMembershipSortOption.LAST_CREATED;
  // AmityMembershipSortOption.FIRST_CREATED;

  // Available filter options
  // AmityCommunityMembershipFilter.ALL;
  // AmityCommunityMembershipFilter.MEMBER;
  // AmityCommunityMembershipFilter.NOT_MEMBER;

  void queryCommunityMembers(
      String communityId,
      AmityMembershipSortOption sortOption,
      AmityCommunityMembershipFilter filter) {
    _communityMembersController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(communityId)
          .getMembers()
          .filter(filter)
          .sortBy(sortOption)
          .roles([
        'community-moderator'
      ]) //optional to query specific members by roles
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_communityMembersController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityCommunityMembers.clear();
            _amityCommunityMembers.addAll(_communityMembersController.loadedItems);
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
