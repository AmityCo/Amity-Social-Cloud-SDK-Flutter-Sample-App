import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../helper/api/post.dart';
import '../robot/login_robot.dart';
import '../robot/feed_robot.dart';
import '../robot/message_robot.dart';

void main() {
  final faker = Faker();
  final myUserId = faker.randomGenerator.numberOfLength(5);
  group('Message Test', () {
    testWidgets('C264306 - User able to create text messages in community Channel',
        (widgetTester) async {
      final loginRobot = LoginRobot(widgetTester);
      final messageRobot = ChatMessageRobot(widgetTester);
      const channelName = "C264306_Community";
      const message = "C264306 SMS text";

      await loginRobot.login(
          myUserId,
          myUserId,
          "b0efe90c69ddf2604a63d81853081688840088b6e967397e",
          AmityRegionalHttpEndpoint.STAGING.value);

      await messageRobot.joinChannelInChannelList(channelName);
      await messageRobot.sendMessage(channelName,message);

      expect(find.textContaining(message, findRichText: true), findsOneWidget);
    });
  });
}
