import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionCommentRemove {
  /* begin_sample_code
    gist_id: 3a72bcc5cdbebe27ffb2c01033ef3362
    filename: AmityReactionCommentRemove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add reaction in comment example
    */
  void removeCommentReaction(AmityComment comment) {
    comment.react().removeReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
