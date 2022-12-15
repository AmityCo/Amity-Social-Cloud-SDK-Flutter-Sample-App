import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageFlag {
  /* begin_sample_code
    gist_id: 2a66124969de71a35a81779f27644f03
    filename: AmityMessageFlag.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag message example
    */
  void flagMessage(AmityMessage message) {
    message.flag().then((value) {
      //success
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
