import 'package:amity_sdk/amity_sdk.dart';

class AmityUserFlagInitialization {
  /* begin_sample_code
    gist_id: 17854e36bf88b63a20e53f4ef8379a1f
    filename: AmityUserFlagInitialization.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter user flag initialization  example
    */
  void initializeUserFlagger(AmityUser user) {
    final flagger = user.report();
  }
  /* end_sample_code */
}
