import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/common_finder_extension.dart';
import '../helper/widget_tester_extension.dart';

void main() {
  group('Login Test', () {
    testWidgets('Verify Login', (widgetTester) async {
      await widgetTester.pumpRouterApp();

      await AmityCoreClient.setup(
        option: AmityCoreClientOption(
            apiKey: 'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
            httpEndpoint: AmityRegionalHttpEndpoint.STAGING,
            showLogs: true),
        sycInitialization: true,
      );

      await AmityCoreClient.login('victimAndroid')
          .displayName('Victim Android')
          .submit();

      await widgetTester
          .pumpNewRoute(AppRoute.chat, params: {'channelId': '123344'});
      // await widgetTester.pumpAndSettle();

      // final loginRobot = LoginRobot(widgetTester);

      // await loginRobot.fillLoginForm(
      //     'victimAndroid',
      //     'Victim Android',
      //     'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
      //     AmityRegionalHttpEndpoint.STAGING.value);

      // await widgetTester.pumpAndSettle(const Duration(seconds: 2));

      // await loginRobot.loginTap();

      await widgetTester.pumpForSeconds(10);

      expect(find.byStringKey('chat_screen_key'), findsOneWidget);
    });
  });
}
