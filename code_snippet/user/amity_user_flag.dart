import 'package:amity_sdk/amity_sdk.dart';

class AmityUserFlag {
  /* begin_sample_code
    gist_id: 89269b8e6bf4f447744c777f8c8a5336
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
