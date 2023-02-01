import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_router.dart';
import 'package:flutter_social_sample_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common_finder_extension.dart';

extension WidgetTesterExtension on WidgetTester {
  // CommonFinders byValueKey(String key)=> byKey(const ValueKey(key));
  Future<void> pumpApp(Widget widget) async {
    return pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
  }

  // Always Required, and by defualt this will login screen
  Future<void> pumpMyApp() async {
    return pumpWidget(MyApp());
  }

  Future<void> pushNewRoute(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) async {
    return AppRouter.router
        .pushNamed(name, params: params, queryParams: params);
  }

  Future delay(int ms) async {
    return pumpAndSettle(Duration(milliseconds: ms));
  }

  Future tapByKey(String key) async {
    return tap(find.byStringKey(key));
  }

  Future<void> pumpForSeconds(int seconds) async {
    bool timerDone = false;
    Timer(Duration(seconds: seconds), () => timerDone = true);
    while (timerDone != true) {
      await pump();
    }
  }

  Future<void> pumpUntilFound(Finder finder,
      {Duration timeout = const Duration(seconds: 30)}) async {
    bool timerDone = false;
    final timer = Timer(
        timeout, () => throw TimeoutException("Pump until has timed out"));
    while (timerDone != true) {
      await pump();

      final found = any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }
}
