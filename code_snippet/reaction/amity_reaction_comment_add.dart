import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionCommentAdd {
  /* begin_sample_code
    gist_id: b16e7e14f5bceb07b115ac420d43a826
    filename: AmityReactionCommentAdd.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add reaction in comment example
    */
  void addCommentReaction(AmityComment comment) {
    comment.react().addReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
