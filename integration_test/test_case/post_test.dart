import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../helper/api/post.dart';
import '../robot/login_robot.dart';
import '../robot/feed_robot.dart';

void main() {
  final faker = Faker();
  final postAPI = PostAPI();
  final userOne = faker.randomGenerator.numberOfLength(5);
  group('Post Test', () {
    // C228850
    testWidgets('C228850 - Make sure can comment on post successfully',
        (widgetTester) async {
      final loginRobot = LoginRobot(widgetTester);
      final feedRoBot = FeedRobot(widgetTester);
      final globalFeedMenu = find.text("Global Feed");
      const post = "C228850 - Make sure can comment on post successfully";
      const comment = "Make sure can comment on post successfully";

      await loginRobot.login(
          userOne,
          userOne,
          "b0efe90c69ddf2604a63d81853081688840088b6e967397e",
          AmityRegionalHttpEndpoint.STAGING.value);

      await postAPI.createPost(userOne, post);
      await widgetTester.tap(globalFeedMenu);
      await widgetTester.pumpAndSettle();
      await feedRoBot.enterComment(comment);
      await feedRoBot.sendComment();
      await feedRoBot.tapCommentButton();

      expect(find.textContaining(comment, findRichText: true), findsOneWidget);
    });
  });
}
