import 'package:amity_sdk/amity_sdk.dart';
import 'package:faker/faker.dart';

class AmitySdkHelper {
  static Future setup(String apikey, AmityRegionalHttpEndpoint server) async {
    await AmityCoreClient.setup(
      option: AmityCoreClientOption(
          apiKey: apikey, httpEndpoint: server, showLogs: true),
      sycInitialization: true,
    );
  }

  static Future login(String userId, [String? displayName]) async {
    await AmityCoreClient.login(userId).displayName(displayName ?? '').submit();
  }

  static Future loginRamdom() async {
    await AmityCoreClient.login(faker.randomGenerator.numberOfLength(5))
        .submit();
  }
}
