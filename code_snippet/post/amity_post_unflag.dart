import 'package:amity_sdk/amity_sdk.dart';

class AmityPostUnflag {
  /* begin_sample_code
    gist_id: a2ca8917013886062803dc770224bf66
    filename: AmityPostUnflag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unflag post example
    */
  void unflagPost(AmityPost post) {
    post.report().unflag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
