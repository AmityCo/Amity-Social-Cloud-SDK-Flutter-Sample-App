import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageUnflag {
  /* begin_sample_code
    gist_id: 74827599992fd693530f96cf68d7e7cc
    filename: AmityMessageUnflag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unflag message example
    */
  void unflagMessage(AmityMessage message) {
    message.unflag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
