import 'package:amity_sdk/amity_sdk.dart';

class AmityPostUpdate {
  /* begin_sample_code
    gist_id: 7bbfcfd4bbffaff62e857b7162001e31
    filename: AmityPostUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update post example
    */
  void updatePost(AmityPost post) {
    post.edit().text('updated post content').update().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
