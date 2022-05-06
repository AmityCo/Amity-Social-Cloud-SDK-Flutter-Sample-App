import 'package:amity_sdk/amity_sdk.dart';

class AmityUserLogout {
  /* begin_sample_code
    gist_id: 64432b7ba5b93c3f9e0455cb96c22070
    filename: AmityUserLogout.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter logout example
    */
  void logout() async {
    await AmityCoreClient.logout();
  }
  /* end_sample_code */

}
