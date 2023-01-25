import 'package:amity_sdk/amity_sdk.dart';

class AmityHelper {
  static Future setupAll() async {
    String apikey = 'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c';
    String serverUrl = AmityRegionalHttpEndpoint.STAGING.value;
    await AmityCoreClient.setup(
      option: AmityCoreClientOption(
          apiKey: apikey,
          httpEndpoint: AmityRegionalHttpEndpoint.values
              .where((element) => element.value == serverUrl)
              .first,
          showLogs: true),
      sycInitialization: true,
    );

    // await Future.delayed(Duration(seconds: 1));

    //Login the user
    String userId = 'victimAndroid';
    String userDisplayName = 'Victim Android';

    final amityUser = await AmityCoreClient.login(userId)
        .displayName(userDisplayName)
        .submit();
  }
}
