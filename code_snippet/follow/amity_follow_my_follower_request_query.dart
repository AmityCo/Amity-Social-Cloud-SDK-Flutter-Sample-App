import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowMyFollowerRequestQuery {
  /* begin_sample_code
    gist_id: 5ab4783bfe02c5ec390c78e2cc2a83b3
    filename: AmityFollowMyFollowerRequestQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter my follower request query info example
    */
  final _followRelationships = <AmityFollowRelationship>[];
  late PagingController<AmityFollowRelationship> _followerController;

  void queryFollowers() {
    _followerController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .me()
          .getFollowers()
          .status(AmityFollowStatusFilter.PENDING)
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
