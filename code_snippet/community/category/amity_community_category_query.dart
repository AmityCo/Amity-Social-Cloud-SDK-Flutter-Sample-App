import 'package:amity_sdk/amity_sdk.dart';

class AmityCategoryQuery {
  /* begin_sample_code
    gist_id: 27190fcd902079993a9eef841267a2df
    filename: AmityCategoryQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query community categories example
    */
  final _amityCategories = <AmityCommunityCategory>[];
  late PagingController<AmityCommunityCategory> _communityCategoryController;

  //Available sort options
  // AmityCommunityCategorySortOption.NAME;
  // AmityCommunityCategorySortOption.LAST_CREATED;
  // AmityCommunityCategorySortOption.FIRST_CREATED;

  void queryCommunityCategories(AmityCommunityCategorySortOption sortOption) {
    _communityCategoryController = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .getCategories()
          .sortBy(sortOption)
          .includeDeleted(true)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_communityCategoryController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityCategories.clear();
            _amityCategories.addAll(_communityCategoryController.loadedItems);
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
