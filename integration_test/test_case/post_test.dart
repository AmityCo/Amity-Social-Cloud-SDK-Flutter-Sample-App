import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_tester_extension.dart';
import '../robot/login_robot.dart';
import '../robot/global_feed_robot.dart';

void main() {
  group('Post Test', () {
    // C228850
    testWidgets('Make sure can comment on post successfully',
        (widgetTester) async {
      final loginRobot = LoginRobot(widgetTester);
      final globalfeedRoBot = GlobalFeedRobot(widgetTester);
      final globalFeedMenu = find.text("Global Feed");
      const comment = "Make sure can comment on post successfully";

      await widgetTester.pumpRouterApp(AppRoute.loginRoute);
      await widgetTester.pumpAndSettle();
      await loginRobot.fillLoginForm(
          'victimAndroid',
          'Victim Android',
          'b0efe90c3bdda2304d628918520c1688845889e4bc363d2c',
          AmityRegionalHttpEndpoint.STAGING.value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 2));
      await loginRobot.loginTap();
      await widgetTester.pumpForSeconds(10);
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetUser('victimAndroid')
          .text("C228850 - Make sure can comment on post successfully")
          .post();

      await widgetTester.tap(globalFeedMenu);
      await widgetTester.pumpAndSettle();
      await globalfeedRoBot.enterComment(comment);
      await globalfeedRoBot.sendComment();
      await globalfeedRoBot.tapCommentButton();

      expect(find.textContaining(comment, findRichText: true), findsOneWidget);
    });
  });
}
