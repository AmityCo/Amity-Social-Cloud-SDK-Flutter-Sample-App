import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageCustomView {
  /* begin_sample_code
    gist_id: 7446eaed453c4c62a950fcd1550afb68
    filename: AmityMessageCustomView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message custom view example
    */
  void viewCustomMessage(AmityMessage message) {
    if (message.data is MessageCustomData) {
      final jsonObject = (message.data as MessageCustomData).rawData;
    }
  }
  /* end_sample_code */
}
