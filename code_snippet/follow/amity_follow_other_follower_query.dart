import 'package:amity_sdk/amity_sdk.dart';

class AmityFollowOtherFollowerQuery {
  /* begin_sample_code
    gist_id: fa886fc0edc55362d28c150c0f259881
    filename: AmityFollowOtherFollowerQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter other's follower query info example
    */
  final _followRelationships = <AmityFollowRelationship>[];
  late PagingController<AmityFollowRelationship> _followerController;

  void queryFollowers(String userId) {
    _followerController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .user(userId = userId)
          .getFollowers()
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
