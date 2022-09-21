import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionMessageRemove {
  /* begin_sample_code
    gist_id: 33be722beb06c9fb68af44c656e2aec1
    filename: AmityReactionMessageRemove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add reaction in message example
    */
  void removeMessageReaction(AmityMessage comment) {
    comment.react().removeReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
