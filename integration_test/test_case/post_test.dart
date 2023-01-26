import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_tester_extension.dart';
import '../robot/login_robot.dart';
import '../robot/global_feed_robot.dart';

void main() {
  group('Post Test', () {
    // C228850
    testWidgets('C228850 - Make sure can comment on post successfully',
        (widgetTester) async {
      final loginRobot = LoginRobot(widgetTester);
      final globalfeedRoBot = GlobalFeedRobot(widgetTester);
      final globalFeedMenu = find.text("Global Feed");
      const comment = "Make sure can comment on post successfully";

      await loginRobot.fillLoginForm(
          'victimAndroid',
          'Victim Android',
          'b0efe90c69ddf2604a63d81853081688840088b6e967397e',
          AmityRegionalHttpEndpoint.STAGING.value);

      await widgetTester.pumpAndSettle();
      await loginRobot.loginTap();
      await widgetTester.pumpForSeconds(3);
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
