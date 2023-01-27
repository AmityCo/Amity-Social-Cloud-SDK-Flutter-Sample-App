import 'package:amity_sdk/amity_sdk.dart';

class AmityUserSearchByDisplayName {
  /* begin_sample_code
    gist_id: 6a732f6953a3cc445c2510b798fd3692
    filename: AmityUserGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get user example
    */
  final _amityUsers = <AmityUser>[];
  late PagingController<AmityUser> _amityUsersController;

  void serarchUserByDisplayName(String keyword) {
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
