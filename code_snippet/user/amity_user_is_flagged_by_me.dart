import 'package:amity_sdk/amity_sdk.dart';

class AmityUserIsFlaggedByMe {
  /* begin_sample_code
    gist_id: 9a296a34273f6a8bdfea76a652f452a1
    filename: AmityUserIsFlaggedByMe.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter user check is flagged by current user example
    */
  void isFlaggedByMe(AmityUser user) {
    if (user.isFlaggedByMe) {
      //Success
      //User is flagged by current user
    } else {
      //User is not flagged by current user
    }
  }
  /* end_sample_code */
}
