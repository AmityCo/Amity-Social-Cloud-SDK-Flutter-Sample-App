import 'package:amity_sdk/amity_sdk.dart';

class AmityUserCreation {
  /* begin_sample_code
    gist_id: fd3786704c153809097973272591f338
    filename: AmityUserCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter login example
    */
  void createUser() async {
    await AmityCoreClient.login('userId')
        .displayName('userDisplayName')
        .submit();
  }
  /* end_sample_code */

}
