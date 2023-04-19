import 'package:amity_sdk/amity_sdk.dart';

class AmityUserGetBlockedUsers {
  /* begin_sample_code
    gist_id: b7cbb5637bbaefa62810a5bed5e8dcd5
    filename: amity_user_get_blocked_users.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get blocked users example
    */
  final _amityUsers = <AmityUser>[];
  late PagingController<AmityUser> _amityUsersController;

  void getBlockedUsers() {
    _amityUsersController = PagingController(
      pageFuture: (token) =>
          AmityCoreClient.newUserRepository().getBlockedUsers().getPagingData(token: token, limit: 20),
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
