// import 'package:amity_sdk/flutter_application_1.dart';
import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_social_sample_app/core/route/app_router.dart';
import 'package:flutter_social_sample_app/core/service_locator/service_locator.dart';
import 'package:flutter_social_sample_app/core/widget/user_suggestion_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      // Replace with actual values
      options: const FirebaseOptions(
        apiKey: "AIzaSyBtsRMyP3H1REHoNrK_TrNiwgVh11koWRU",
        appId: "1:1056361182889:android:9f2e636fda6efff5ac1bb8",
        messagingSenderId: "AIzaSyBtsRMyP3H1REHoNrK_TrNiwgVh11koWRU",
        projectId: "1056361182889",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  await AppServiceLocator.initServiceLocator();
  await AmityCoreClient.setup(
      option: AmityCoreClientOption(
          apiKey: "b0efe90c3bdda2304d628918520c1688845889e4bc363d2c",
          httpEndpoint: AmityRegionalHttpEndpoint(
              AmityRegionalHttpEndpoint.custom('https://api.staging.amity.co/')
                  .endpoint),
          // mqttEndpoint: AmityRegionalMqttEndpoint.custom('ssq.dev.amity.co'),
          mqttEndpoint:
              AmityRegionalMqttEndpoint.custom('ssq.staging.amity.co'),
          // mqttEndpoint: AmityRegionalMqttEndpoint.SG,
          showLogs: true),
      sycInitialization: true,
    );

  //gloabl init
  // await AmityCoreClient.setup(
  //   option: AmityCoreClientOption(
  //       apiKey: 'b3bee858328ef4344a308e4a5a091688d05fdee2be353a2b',
  //       httpEndpoint: AmityRegionalHttpEndpoint.STAGING,
  //       showLogs: true),
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        UserSuggesionOverlay.instance.hideOverLay();
      }
    });
  }

  late String userId;
  late String userDisplayName;
  @override
  Widget build(BuildContext context) {
    userId = 'victimAndroid';
    userDisplayName = 'victimAndroid';
    final themeData = Theme.of(context);
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        textTheme: themeData.textTheme.apply(bodyColor: Colors.black),
        iconTheme: const IconThemeData(color: Colors.grey, size: 18),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        snackBarTheme:
            themeData.snackBarTheme.copyWith(backgroundColor: Colors.white),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: Colors.white),
      ),
      themeMode: ThemeMode.light,
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
