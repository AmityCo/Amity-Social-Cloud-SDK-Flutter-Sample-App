import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageTextView {
  /* begin_sample_code
    gist_id: d90b1de36e2a83b839742b474fe044c3
    filename: AmityMessageTextView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message text view example
    */
  void viewTextMessage(AmityMessage message) {
    if (message.data is MessageTextData) {
      final text = (message.data as MessageTextData).text;
    }
  }
  /* end_sample_code */
}
