import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/common_finder_extension.dart';
import '../helper/widget_tester_extension.dart';
import '../robot/login_robot.dart';

void main() {
  group('Login Test', () {
    testWidgets('Verify Login', (widgetTester) async {
      // await widgetTester.pumpRouterApp(AppRoute.loginRoute);

      await widgetTester.pumpAndSettle();

      final loginRobot = LoginRobot(widgetTester);


      await loginRobot.fillLoginForm(
          'victimAndroid',
          'Victim Android',
          'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
          AmityRegionalHttpEndpoint.custom('https://api.staging.amity.co/').endpoint);

      await widgetTester.pumpAndSettle(const Duration(seconds: 2));

      await loginRobot.loginTap();

      await widgetTester.pumpForSeconds(10);

      expect(find.byStringKey('dashboard_screen_key'), findsOneWidget);
    });
  });
}
