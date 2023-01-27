import 'package:amity_sdk/amity_sdk.dart';

class AmityUserGetUsers {
  /* begin_sample_code
    gist_id: ee07f318a29fc7db6f103487f5f32b78
    filename: AmityUserGetUsers.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get users example
    */
  final _amityUsers = <AmityUser>[];
  late PagingController<AmityUser> _amityUsersController;

  // Available sort options
  // AmityUserSortOption.DISPLAY;
  // AmityUserSortOption.FIRST_CREATED;
  // AmityUserSortOption.LAST_CREATED;

  void getUsers(AmityUserSortOption amityUserSortOption) {
    _amityUsersController = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .getUsers()
          .sortBy(amityUserSortOption)
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
