
import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import '../helper/amity_sdk_helper.dart';
import '../helper/api/channel.dart';
import '../helper/widget_tester_extension.dart';
import '../robot/message_robot.dart';

void main() {
  const apiKey = "b0efe90c69ddf2604a63d81853081688840088b6e967397e";
  final faker = Faker();
  final channelAPI = ChannelAPI();
  final myUserId = faker.randomGenerator.numberOfLength(5);
  final channelId = faker.randomGenerator.numberOfLength(10);
  final displayName = faker.randomGenerator.numberOfLength(10);

  // Once per file
  setUpAll(() async {
    await AmitySdkHelper.setup(apiKey, AmityRegionalHttpEndpoint.STAGING);
  });

  // Runs with each test in the file
  setUp(() async {
    await AmitySdkHelper.login(myUserId);
  });

  group('Message Test', () {
    testWidgets('C264306 - User able to create text messages in community Channel',
            (widgetTester) async {
          await widgetTester.pumpMyApp();
          final messageRobot = ChatMessageRobot(widgetTester);
          const message = "C264306 SMS text";

          await channelAPI.createCommunityChannel(channelId, displayName);
          await messageRobot.openChatScreen(channelId);
          await messageRobot.sendMessage(channelId,message);
          expect(find.textContaining(message, findRichText: true), findsOneWidget);
        });
  });
}