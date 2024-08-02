import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberSearchByKeyword {
  /* begin_sample_code
    gist_id: ea7c1c5243209d65ceecc7f0e5eff00d
    filename: AmityCommunityMemberSearchByKeyword.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter search community members by keyword example
    */
  final _amityCommunityMembers = <AmityCommunityMember>[];
  late PagingController<AmityCommunityMember> _communityMembersController;

  // Available sort options
  // AmityCommunityMembershipSortOption.LAST_CREATED;
  // AmityCommunityMembershipSortOption.FIRST_CREATED;

  // Available filter options
  // AmityCommunityMembershipFilter.ALL;
  // AmityCommunityMembershipFilter.MEMBER;
  // AmityCommunityMembershipFilter.NOT_MEMBER;

  void searchCommunityMembers(
      String communityId,
      String keyword,
      AmityCommunityMembershipSortOption sortOption,
      AmityCommunityMembershipFilter filter) {
    _communityMembersController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(communityId)
          .searchMembers(keyword)
          .filter(filter)
          .sortBy(sortOption)
          .includeDeleted(false) // optional to filter deleted users from the result
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
            _amityCommunityMembers
                .addAll(_communityMembersController.loadedItems);
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
