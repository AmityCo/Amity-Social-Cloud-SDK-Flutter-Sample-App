import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../helper/api/post.dart';
import '../robot/login_robot.dart';
import '../robot/global_feed_robot.dart';

void main() {
  final faker = Faker();
  final userOne = faker.randomGenerator.numberOfLength(10);
  final postAPI = PostAPI();
  group('Post Test', () {
    // C228850
    testWidgets('C228850 - Make sure can comment on post successfully',
        (widgetTester) async {
      final loginRobot = LoginRobot(widgetTester);
      final globalfeedRoBot = GlobalFeedRobot(widgetTester);
      final globalFeedMenu = find.text("Global Feed");
      const post = "C228850 - Make sure can comment on post successfully";
      const comment = "Make sure can comment on post successfully";

      loginRobot.login(
          userOne,
          userOne,
          "b0efe90c69ddf2604a63d81853081688840088b6e967397e",
          AmityRegionalHttpEndpoint.STAGING.value);

      await postAPI.createPost(userOne, post);
      await widgetTester.tap(globalFeedMenu);
      await widgetTester.pumpAndSettle();
      await globalfeedRoBot.enterComment(comment);
      await globalfeedRoBot.sendComment();
      await globalfeedRoBot.tapCommentButton();

      expect(find.textContaining(comment, findRichText: true), findsOneWidget);
    });
  });
}
