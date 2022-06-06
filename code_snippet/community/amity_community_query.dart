import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityQuery {
  /* begin_sample_code
    gist_id: d22e645d88768aeb6c0ab69c9bca0525
    filename: AmityCommunityQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query communities example
    */
  final _amityCommunities = <AmityCommunity>[];
  late PagingController<AmityCommunity> _communityController;

  //Available sort options
  // AmityCommunitySortOption.DISPLAY_NAME;
  // AmityCommunitySortOption.LAST_CREATED;
  // AmityCommunitySortOption.FIRST_CREATED;

  // Available filter options
  // AmityCommunityFilter.ALL;
  // AmityCommunityFilter.MEMBER;
  // AmityCommunityFilter.NOT_MEMBER;

  void queryCommunities(
      AmityCommunitySortOption sortOption, AmityCommunityFilter filter) {
    _communityController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .getCommunities()
          .filter(filter)
          .sortBy(sortOption)
          .includeDeleted(true)
          .withKeyword('hello') //optional for searching communities
          .categoryId(
              'id') //optional filter communities based on community categories
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_communityController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityCommunities.clear();
            _amityCommunities.addAll(_communityController.loadedItems);
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
