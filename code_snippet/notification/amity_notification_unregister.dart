import 'package:amity_sdk/amity_sdk.dart';

class AmityNotificationUnregister {
  /* begin_sample_code
    gist_id: 849f272d0c6133887ae19fc1200f261f
    filename: AmityNotificationUnregister.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter unregister notification example
    */
  void unregisterNotification() {
    AmityCoreClient.unregisterDeviceNotification()
        .then((value) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
