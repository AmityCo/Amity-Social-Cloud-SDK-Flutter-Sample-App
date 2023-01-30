import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FeedRobot {
  final WidgetTester widgetTester;

  FeedRobot(this.widgetTester);

  final globalFeedMenu = find.text("Global Feed");
  final commentInput = find.byKey(const Key("comment_input")).first;
  final sendIcon = find.byIcon(Icons.send_rounded).first;
  final commentButton = find.byKey(const Key("feed_action_comment")).first;

  Future enterComment(comment) async {
    await widgetTester.enterText(commentInput, comment);
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
