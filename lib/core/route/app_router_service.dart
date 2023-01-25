import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_router.dart';
import 'package:go_router/go_router.dart';

class AppRouterService {
  static AppRouterService? _instance;

  AppRouterService._();

  static AppRouterService get instance => _instance ??= AppRouterService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _router = AppRouter.router();
  GoRouter get router => _router;

  Future<void> pumpNewRoute(String route,
      {Map<String, String>? params, Map<String, String>? queryParams}) async {
    return _router.pushNamed(route,
        params: params ?? const <String, String>{},
        queryParams: queryParams ?? const <String, String>{});
  }
}
