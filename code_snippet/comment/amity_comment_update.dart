import 'package:amity_sdk/amity_sdk.dart';


class AmityCommentUpdate {
  /* begin_sample_code
    gist_id: 893357a8ae37f04677e5704bfacec50d
    filename: AmityCommentUpdate.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter update text comment example
    */
  void updateComment(AmityComment comment) {
    comment
        .edit()
        .text("Updated comment from me :D")
        .update()
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
