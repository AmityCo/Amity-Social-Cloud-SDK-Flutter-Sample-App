import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import '../helper/widget_tester_extension.dart';

class ChannelRobot {
  final WidgetTester widgetTester;
  ChannelRobot(this.widgetTester);

  Future goToChannelList()async{
    // Go to Create Channel Page
    final gotoChannelList =find.text('Channel List');
    await widgetTester.tap(gotoChannelList);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(2);
  }

  Future createNewChannel(String channelId, String channelName, String CommaTags,
      String CommaUserId, String metadata) async {
    await widgetTester.tapByKey('create_new_btn');
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final communityChannel =find.text('Community');
    await widgetTester.tap(communityChannel);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    /// Write the code to fill the channel details info in TextFormField
    final channel_id = find.byKey(Key("channel_id_txt"));
    final channel_Name = find.byKey(Key("channel_name_txt"));
    final comma_Tags = find.byKey(Key("comma_tag_txt"));
    final commaUser_Ids = find.byKey(Key("comma_user_ids_txt"));
    final commaChannel_Metadata = find.byKey(Key("channel_metadata_txt"));

    await widgetTester.enterText(channel_id, channelId);
    await widgetTester.enterText(channel_Name, channelName);
    await widgetTester.enterText(comma_Tags, CommaTags);
    await widgetTester.enterText(commaUser_Ids, CommaUserId);
    await widgetTester.enterText(commaChannel_Metadata, metadata);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final tapJoinButton =find.text('Create Channel');
    await widgetTester.tap(tapJoinButton);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(5);
  }


  Future joinChannelById(String channel_id) async {
    await widgetTester.pumpRouterApp(AppRoute.channelListRoute);
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final channel_id_txt = find.byKey(const Key("channel_id"));
    await widgetTester.enterText(channel_id_txt, channel_id);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(2);
    final channelTap = find.byKey(const Key("channel_search_result_id"));
    await widgetTester.tap(channelTap);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final tapJoinButton =find.text('Join');
    await widgetTester.tap(tapJoinButton);
    await widgetTester.pumpAndSettle();
  }

  Future sendTextMessage(String channel_id,String message) async {
    await widgetTester.pumpRouterApp(AppRoute.homeRoute);
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final chatScreen = find.text('Chat Screen');
    await widgetTester.tap(chatScreen);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(2);
    final channel_name_txt = find.byKey(const Key("channel_name"));
    await widgetTester.enterText(channel_name_txt, channel_id);
    final tapJoinButton = find.text('Join');
    await widgetTester.tap(tapJoinButton);
    await widgetTester.pumpAndSettle(const Duration(seconds: 2));
    final message_text = find.byKey(const Key("message_txtfield"));
    await widgetTester.enterText(message_text, message);
    await widgetTester.pumpForSeconds(2);
    final send = find.byKey(const Key("send_btn"));//key: const Key('send_btn'),
    await widgetTester.tap(send);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(5);
  }

  Future hideKeyboard()async {
    FocusManager.instance.primaryFocus?.unfocus();

  }
}
