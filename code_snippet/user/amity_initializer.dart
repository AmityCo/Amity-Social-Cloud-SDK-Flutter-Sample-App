import 'package:amity_sdk/amity_sdk.dart';

class AmityInitializer {
  /* begin_sample_code
    gist_id: 7fe9f404dcdc6d16fe9cf9caafd11f6c
    filename: AmityInitializer.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter setup
    */
  void setup() async {
    await AmityCoreClient.setup(
        option: AmityCoreClientOption(
          apiKey: 'apikey',
          httpEndpoint: AmityRegionalHttpEndpoint.SG,
        ),
        sycInitialization: true);
  }
  /* end_sample_code */

}
