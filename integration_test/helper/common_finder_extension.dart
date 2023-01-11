import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFinderExtension on CommonFinders {
  Finder byValueKey(String key) {
    return byKey(ValueKey(key));
  }

  Finder byStringKey(String key) {
    return byKey(Key(key));
  }

  T byKeyType<T>(Key key) {
    return byKey(const ValueKey('order_reminder_switch'))
        .evaluate()
        .single
        .widget as T;
  }
}
