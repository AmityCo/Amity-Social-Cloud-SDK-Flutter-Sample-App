import 'package:amity_sdk/amity_sdk.dart';

class AmityUserGet {
  /* begin_sample_code
    gist_id: 6a732f6953a3cc445c2510b798fd3692
    filename: AmityUserGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get user example
    */
  void getUser() {
    AmityCoreClient.newUserRepository()
        .getUser('userId')
        .then((AmityUser user) {
      //handle result
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
