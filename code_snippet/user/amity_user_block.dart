import 'package:amity_sdk/amity_sdk.dart';

class AmityUserBlock {
  /* begin_sample_code
    gist_id: 7ff13cf7eaa70fce5b593452b7e56ade
    filename: amity_user_block.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter Block user example
    */
  void blockUser(AmityUser user) {
    user.relationship().block().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
