import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GlobalFeedRobot {
  final WidgetTester widgetTester;

  GlobalFeedRobot(this.widgetTester);

  final globalFeedMenu = find.text("Global Feed");
  final commentTextFormField = find.byKey(const Key("text_form_field")).first;
  final sendIcon = find.byIcon(Icons.send_rounded).first;
  final commentButton = find.text("Comment").first;

  Future enterComment(comment) async {
    await widgetTester.enterText(commentTextFormField, comment);
    await widgetTester.pumpAndSettle();
  }

  Future sendComment() async {
    await widgetTester.tap(sendIcon);
    await widgetTester.pumpAndSettle();
  }

  Future tapCommentButton() async {
    await widgetTester.tap(commentButton);
    await widgetTester.pumpAndSettle();
  }
}
