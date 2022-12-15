import 'package:amity_sdk/amity_sdk.dart';

class AmityUserFlagInitialization {
  /* begin_sample_code
    gist_id: a64f66b4df447fd87c4cbff25fea843e
    filename: AmityUserFlagInitialization.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter user flag initialization  example
    */
  void initializeUserFlagger(AmityUser user) {
    final flagger = user.report();
  }
  /* end_sample_code */
}
