import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentUnflag {
  /* begin_sample_code
    gist_id: 153e5d152eac89f1050a9c1e32481b8b
    filename: AmityCommentUnflag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unflag comment example
    */
  void unflagComment(AmityComment comment) {
    comment.report().unflag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
