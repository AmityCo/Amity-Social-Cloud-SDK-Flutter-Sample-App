import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowOtherFollowingQuery {
  /* begin_sample_code
    gist_id: 4b5c3699dc13fb04078efcc7e12dbea2
    filename: AmityFollowOtherFollowingQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter other's following query info example
    */
  final _followRelationships = <AmityFollowRelationship>[];
  late PagingController<AmityFollowRelationship> _followerController;

  void queryFollowings(String userId) {
    _followerController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .getFollowings(userId)
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
