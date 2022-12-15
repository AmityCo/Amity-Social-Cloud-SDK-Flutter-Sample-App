import 'package:amity_sdk/amity_sdk.dart';

class AmityUserUnflag {
  /* begin_sample_code
    gist_id: b4b4222bda5f64a3550419c45b9ade70
    filename: AmityUserUnFlag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unflag user example
    */
  void unflagUser(AmityUser user) {
    user.report().unflag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
