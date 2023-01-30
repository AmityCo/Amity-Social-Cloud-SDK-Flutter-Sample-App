import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helper/common_finder_extension.dart';
import '../helper/utils.dart';
import '../helper/widget_tester_extension.dart';
import '../robot/login_robot.dart';
import '../robot/channel_robot.dart';

//test

void main() {
  final genKeys = Utility();
  group('Message Test', () {
    testWidgets('264306 Message Send InChannel', (widgetTester) async {
      var myUserId = 'user_id'+ genKeys.generateRandom(5);
      var channel_id = 'C264306_Community';
      var message = 'Text_SMS_' +genKeys.generateRandom(5);
      //Login
      final loginRobot = LoginRobot(widgetTester);
      await loginRobot.fillLoginForm(
          myUserId,
          myUserId,
          'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
          AmityRegionalHttpEndpoint.STAGING.value);
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      await loginRobot.loginTap();
      await widgetTester.pumpForSeconds(2);
      expect(find.byStringKey('dashboard_screen_key'), findsOneWidget);

      final channelRobot = ChannelRobot(widgetTester);
      await channelRobot.joinChannelById(channel_id);
      await channelRobot.sendTextMessage(channel_id,message);
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.textContaining(message,findRichText: true), findsOneWidget);
    });
  });
}
