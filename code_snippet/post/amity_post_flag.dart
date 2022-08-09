import 'package:amity_sdk/amity_sdk.dart';

class AmityPostFlag {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
    filename: AmityPostFlag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag post example
    */
  void flagPost(AmityPost post) {
    post.report().flag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
