import 'package:amity_sdk/amity_sdk.dart';

class AmityReactionMessageAdd {
  /* begin_sample_code
    gist_id: d8881198e9354aabc189143cb84e4b28
    filename: AmityReactionMessageAdd.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add reaction in message example
    */
  void addMessageReaction(AmityMessage message) {
    message.react().addReaction('like').then((value) => {
          //success
        });
  }

  /* end_sample_code */
}
