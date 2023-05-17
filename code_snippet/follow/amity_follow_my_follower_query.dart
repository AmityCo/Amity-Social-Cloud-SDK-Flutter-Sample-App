import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowMyFollowerQuery {
  /* begin_sample_code
    gist_id: 47d03022e1700fa99ea1e8cadf55d414
    filename: AmityFollowMyFollowerQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter my follower query info example
    */
  final _followRelationships = <AmityFollowRelationship>[];
  late PagingController<AmityFollowRelationship> _followerController;

  void queryFollowers() {
    _followerController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .getMyFollowers()
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
