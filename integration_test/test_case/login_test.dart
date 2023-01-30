import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/common_finder_extension.dart';
import '../helper/utils.dart';
import '../helper/widget_tester_extension.dart';
import '../robot/login_robot.dart';

//test

void main() {
  group('Login Test', () {
    testWidgets('Verify Login', (widgetTester) async {
      await widgetTester.pumpRouterApp(AppRoute.loginRoute);

      await widgetTester.pumpAndSettle();
      final genKeys = Utility();
      final loginRobot = LoginRobot(widgetTester);

      await loginRobot.fillLoginForm(
          genKeys.generateRandom(9),
          genKeys.generateRandom(9),
          'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
          AmityRegionalHttpEndpoint.STAGING.value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 2));

      await loginRobot.loginTap();

      await widgetTester.pumpForSeconds(5);

      expect(find.byStringKey('dashboard_screen_key'), findsOneWidget);
      await widgetTester.pumpRouterApp(AppRoute.channelListRoute);
   //   expect(find.byStringKey('Message'),findsOneWidget);

    });
  });
}
