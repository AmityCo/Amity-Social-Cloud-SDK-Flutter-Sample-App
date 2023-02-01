import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helper/widget_tester_extension.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';

class ChatMessageRobot {
  final WidgetTester widgetTester;

  ChatMessageRobot(this.widgetTester);

  final chatMenu = find.text("Chat Screen");
  final channelNameInput = find.byKey(const Key("channel_name"));
  final messageInput = find.byKey(const Key("message_text_field"));
  final joinButton = find.text("Join");
  final send = find.byKey(const Key("send_btn"));
  final sendIcon = find.byIcon(Icons.send_rounded).first;
  final commentButton = find.byKey(const Key("feed_action_comment")).first;
  final channel_id_input = find.byKey(const Key("channel_id"));
  final channelTap = find.byKey(const Key("channel_search_result_id"));

  Future joinChannelInChannelList(channelName)async {
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    await widgetTester.enterText(channel_id_input, channelName);
    await widgetTester.pumpForSeconds(6);
    await widgetTester.tap(channelTap);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    await widgetTester.tap(joinButton);
    await widgetTester.pumpAndSettle();
  }

  Future openChatScreen(String channelId)async{
    await widgetTester.pushNewRoute(AppRoute.chat,params: {'channelId':channelId});
  }
  Future sendMessage(channelName,message)async{
    await widgetTester.enterText(messageInput, message);
    await widgetTester.tap(send);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(5);
  }
}