import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentDeletion {
  /* begin_sample_code
    gist_id: d328b9fdadec1720b988528f3b215996
    filename: AmityCommentDeletion.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter delete text comment example
    */
  //current parent comment collection
  final _amityComments = <AmityComment>[];

  void deleteomment(AmityComment comment) {
    comment
        .delete()
        .then((value) => {
              //handle result
              //success
              //optional: to remove the deleted post from the current post collection
              //you will need manually remove the deleted post from the collection
              //for example :
              _amityComments.removeWhere(
                  (element) => element.commentId == comment.commentId)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
