import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentFlag {
  /* begin_sample_code
    gist_id: 4f0ad182dd563356e707e05f3e60fb93
    filename: AmityCommentFlag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag comment example
    */
  void flagComment(AmityComment comment) {
    comment.report().flag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
