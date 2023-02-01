import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../helper/amity_sdk_helper.dart';
import '../helper/api/post.dart';
import '../helper/widget_tester_extension.dart';
import '../robot/global_feed_robot.dart';

void main() {
  const apiKey = "b0efe90c69ddf2604a63d81853081688840088b6e967397e";
  final faker = Faker();
  final postAPI = PostAPI();
  final userOne = faker.randomGenerator.numberOfLength(5);

  // Once per file
  setUpAll(() async {
    await AmitySdkHelper.setup(apiKey, AmityRegionalHttpEndpoint.STAGING);
  });

  // Runs with each test in the file
  setUp(() async {
    await AmitySdkHelper.login(userOne);
  });

  group('Post Test', () {
    // C228850
    testWidgets('C228850 - Make sure can comment on post successfully',
        (widgetTester) async {
      await widgetTester.pumpMyApp();

      final globalfeedRoBot = GlobalFeedRobot(widgetTester);
      const post = "C228850 - Make sure can comment on post successfully";
      const comment = "Make sure can comment on post successfully";

      await postAPI.createPost(userOne, post);
      await widgetTester.pushNewRoute(AppRoute.globalFeed);

      await widgetTester.pumpAndSettle();

      await globalfeedRoBot.sendComment(comment);

      await globalfeedRoBot.tapCommentButton();

      expect(find.textContaining(comment, findRichText: true), findsOneWidget);
    });
  });
}
