import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentDeletion {
  /* begin_sample_code
    gist_id: d328b9fdadec1720b988528f3b215996
    filename: AmityCommentDeletion.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter delete text comment example
    */
  void deleteomment(AmityComment comment) {
    comment
        .delete()
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
