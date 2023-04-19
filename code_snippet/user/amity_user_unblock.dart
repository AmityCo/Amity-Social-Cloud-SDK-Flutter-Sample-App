import 'package:amity_sdk/amity_sdk.dart';

class AmityUserUnblock {
  /* begin_sample_code
    gist_id: 97927bb8041dfcaf12165f28f3658c46
    filename: amity_user_unblock.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unblock user example
    */
  void unBlockUser(AmityUser user) {
    user.relationship().unblock().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
