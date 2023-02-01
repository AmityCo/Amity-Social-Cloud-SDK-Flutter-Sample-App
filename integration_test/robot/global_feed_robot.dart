import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GlobalFeedRobot {
  final WidgetTester widgetTester;

  GlobalFeedRobot(this.widgetTester);

  final globalFeedMenu = find.text("Global Feed");
  final commentInput = find.byKey(const Key("comment_input")).first;
  final sendIcon = find.byIcon(Icons.send_rounded).first;
  final commentButton =
      find.byKey(const Key("feed_action_comment_button")).first;

  Future sendComment(String comment) async {
    await widgetTester.enterText(commentInput, comment);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(sendIcon);
    await widgetTester.pumpAndSettle();
  }

  Future tapCommentButton() async {
    await widgetTester.tap(commentButton);
    await widgetTester.pumpAndSettle();
  }
}
