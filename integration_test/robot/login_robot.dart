import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper/widget_tester_extension.dart';

class LoginRobot {
  final WidgetTester widgetTester;

  LoginRobot(this.widgetTester);

  Future fillLoginForm(String userId, String displayName, String apiKey,
      String serverUrl) async {
    /// Write the code to fill the email in TextFormField
    final userIdTxtField = find.byKey(const Key("user_id_txtip"));
    final displaynameTxtField = find.byKey(const Key("display_name_txtip"));
    final apiKeyTxtField = find.byKey(const Key("api_key_txtip"));
    final urlTxtField = find.byKey(const Key("server_url_txtip"));

    await widgetTester.enterText(userIdTxtField, userId);
    await widgetTester.enterText(displaynameTxtField, displayName);
    await widgetTester.enterText(apiKeyTxtField, apiKey);
    await widgetTester.enterText(urlTxtField, serverUrl);

    await widgetTester.pumpAndSettle();
  }

  Future loginTap() async {
    await widgetTester.tapByKey('Login_btn_id');

    await widgetTester.pumpAndSettle();
  }
}
