import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_tester_extension.dart';

class LoginRobot {
  final WidgetTester widgetTester;
  final userIdTxtField = find.byKey(const Key("user_id_txtip"));
  final displaynameTxtField = find.byKey(const Key("display_name_txtip"));
  final apiKeyTxtField = find.byKey(const Key("api_key_txtip"));
  final urlTxtField = find.byKey(const Key("server_url_txtip"));
  final loginButton = "Login_btn_id";

  LoginRobot(this.widgetTester);

  Future pumpLoginRoute() async {
    await widgetTester.pushNewRoute(AppRoute.loginRoute);
  }

  Future login(String userId, String displayName, String apiKey,
      String serverUrl) async {
    /// Write the code to fill the email in TextFormField
    //

    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(userIdTxtField, userId);
    await widgetTester.enterText(displaynameTxtField, displayName);
    await widgetTester.enterText(apiKeyTxtField, apiKey);
    await widgetTester.enterText(urlTxtField, serverUrl);
    await widgetTester.pumpAndSettle();
    await widgetTester.tapByKey(loginButton);
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpForSeconds(3);
  }
}
