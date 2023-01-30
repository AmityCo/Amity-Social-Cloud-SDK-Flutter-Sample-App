import 'package:amity_sdk/amity_sdk.dart';

class AmityUserSearchByDisplayName {
  /* begin_sample_code
    gist_id: 3ee3dab5280389461b9417ce8a7734d6
    filename: AmityUserSearchByDisplayName.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter search user by display name example
    */
  final _amityUsers = <AmityUser>[];
  late PagingController<AmityUser> _amityUsersController;

  void searchUserByDisplayName(String keyword) {
    _amityUsersController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .searchUserByDisplayName(keyword)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_amityUsersController.error == null) {
            //handle _amityUsersController, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityUsers.clear();
            _amityUsers.addAll(_amityUsersController.loadedItems);
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
