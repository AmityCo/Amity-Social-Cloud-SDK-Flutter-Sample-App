import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionPostAdd {
  /* begin_sample_code
    gist_id: b4f039f00725992ecceebe638b208762
    filename: AmityReactionPostAdd.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add reaction in post example
    */
  void addPostReaction(AmityPost post) {
    post.react().addReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
