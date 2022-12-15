import 'package:amity_sdk/amity_sdk.dart';

class AmityUserUnflag {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
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
