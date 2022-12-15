import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageUnflag {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
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
