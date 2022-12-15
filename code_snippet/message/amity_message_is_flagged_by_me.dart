import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageIsFlaggedByMe {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
    filename: AmityMessageIsFlaggedByMe.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message check is flagged by current user example
    */
  void isFlaggedByMe(AmityMessage message) {
    if (message.isFlaggedByMe) {
      //Success
      //Message is flagged by current user
    } else {
      //Message is not flagged by current user
    }
  }
  /* end_sample_code */
}
