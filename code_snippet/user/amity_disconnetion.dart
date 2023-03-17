import 'package:amity_sdk/amity_sdk.dart';

class AmityDisconnection {
  /* begin_sample_code
    gist_id: 2b5496d0d9c05c386b8ed045582fe667
    filename: AmityDisconnection.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter client disconnection
    */
  void disconnect() async {
    AmityCoreClient.disconnect();
  }
  /* end_sample_code */
}
