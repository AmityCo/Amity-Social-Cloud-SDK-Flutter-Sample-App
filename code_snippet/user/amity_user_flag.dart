import 'package:amity_sdk/amity_sdk.dart';

class AmityUserFlag {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
    filename: AmityUserFlag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag user example
    */
  void flagUser(AmityUser user) {
    user.report().flag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
