import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowMyFollowingQuery {
  /* begin_sample_code
    gist_id: 9c7083acaa6bea6f0f0221faf35a3e1f
    filename: AmityFollowMyFollowingQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter my following query info example
    */
  final _followRelationships = <AmityFollowRelationship>[];
  late PagingController<AmityFollowRelationship> _followerController;

  //Available sort options
  // AmityFollowStatusFilter.ACCEPTED;
  // AmityFollowStatusFilter.PENDING;
  // AmityFollowStatusFilter.ALL;

  void queryFollowings() {
    _followerController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .getMyFollowings()
          .status(AmityFollowStatusFilter.ACCEPTED)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_followerController.error == null) {
            //handle _followerController, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _followRelationships.clear();
            _followRelationships.addAll(_followerController.loadedItems);
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
