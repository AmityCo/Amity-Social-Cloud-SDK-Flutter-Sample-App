import 'package:amity_sdk/amity_sdk.dart';

class AmityUserUpdate {
  /* begin_sample_code
    gist_id: 4203037af5035faa8b1da00eea1e2f4e
    filename: AmityUserUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update user example
    */
  void updateUser() {
    AmityCoreClient.newUserRepository()
        .updateUser('userId')
        .avatarFileId('avatarFileId')
        .description('my description')
        .displayName('display name')
        .update()
        .then((AmityUser user) {
      //handle result
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
