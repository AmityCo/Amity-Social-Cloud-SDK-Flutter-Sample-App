import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import '../helper/widget_tester_extension.dart';

class LoginRobot {
  final WidgetTester widgetTester;

  LoginRobot(this.widgetTester);
  Future fillLoginForm(String userId, String displayName, String apiKey,
      String serverUrl) async {
    await widgetTester.pumpRouterApp(AppRoute.loginRoute);
    await widgetTester.pumpAndSettle();
    /// Write the code to fill the email in TextFormField
    final userIdTxtField = find.byKey(const Key("user_id_txtip"));
    final displayNameTxtField = find.byKey(const Key("display_name_txtip"));
    final apiKeyTxtField = find.byKey(const Key("api_key_txtip"));
    final urlTxtField = find.byKey(const Key("server_url_txtip"));

    await widgetTester.enterText(userIdTxtField, userId);
    await widgetTester.enterText(displayNameTxtField, displayName);
    await widgetTester.enterText(apiKeyTxtField, apiKey);
    await widgetTester.enterText(urlTxtField, serverUrl);
    await widgetTester.pumpAndSettle();
  }

  Future loginTap() async {
    await widgetTester.tapByKey('Login_btn_id');
    await widgetTester.pumpAndSettle();
  }

}
