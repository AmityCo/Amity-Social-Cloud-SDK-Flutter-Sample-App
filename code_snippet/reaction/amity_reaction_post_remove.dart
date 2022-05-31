import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionPostRemove {
  /* begin_sample_code
    gist_id: 3aad1618c44aab5a74519e43292e98a3
    filename: AmityReactionPostRemove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove reaction in post example
    */
  void removePostReaction(AmityPost post) {
    post.react().removeReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
