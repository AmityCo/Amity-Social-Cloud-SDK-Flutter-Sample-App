import 'package:amity_sdk/amity_sdk.dart';

class AmityAuthentication {
  /* begin_sample_code
    gist_id: 4a3d37b5e164655802bdd2c646f9d44a
    filename: AmityAuthentication.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter login example
    */
  void login() async {
    await AmityCoreClient.login('userId')
        .displayName('userDisplayName')
        .submit();
  }
  /* end_sample_code */

}
