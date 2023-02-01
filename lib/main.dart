// import 'package:amity_sdk/flutter_application_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_router.dart';
import 'package:flutter_social_sample_app/core/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

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

  //gloabl init
  // await AmityCoreClient.setup(
  //   option: AmityCoreClientOption(
  //       apiKey: 'b3bee858328ef4344a308e4a5a091688d05fdee2be353a2b',
  //       httpEndpoint: AmityRegionalHttpEndpoint.STAGING,
  //       showLogs: true),
  // );

  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

class MyApp extends StatelessWidget {
  late String userId;
  late String userDisplayName;
  @override
  Widget build(BuildContext context) {
    userId = 'victimAndroid';
    userDisplayName = 'victimAndroid';
    final _themeData = Theme.of(context);
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        textTheme: _themeData.textTheme.apply(bodyColor: Colors.black),
        iconTheme: const IconThemeData(color: Colors.grey, size: 18),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        backgroundColor: Colors.white,
        snackBarTheme:
            _themeData.snackBarTheme.copyWith(backgroundColor: Colors.white),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black),
      ),
      themeMode: ThemeMode.light,
    );
  }
}
