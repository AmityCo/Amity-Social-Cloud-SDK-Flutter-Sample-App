// import 'package:amity_sdk/flutter_application_1.dart';
import 'dart:developer';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_router.dart';
import 'package:flutter_social_sample_app/core/service_locator/service_locator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AppServiceLocator.initServiceLocator();

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
  @override
  void initState() {
    super.initState();
  }

  late String userId;
  late String userDisplayName;
  @override
  Widget build(BuildContext context) {
    userId = 'victimAndroid';
    userDisplayName = 'victimAndroid';
    final _themeData = Theme.of(context);
    return GetMaterialApp.router(
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
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
        tabBarTheme: TabBarTheme(labelColor: Colors.black),
      ),
      themeMode: ThemeMode.light,

      // onGenerateRoute: (settings){
      //   switch(settings.name){

      //   }
      // },
    );
  }

  Scaffold _getTestingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: ListView(
          children: [
            TextButton(
              onPressed: () async {
                AmityCoreClient.login(userId)
                    .displayName(userDisplayName)
                    .submit()
                    .then((value) {
                  log(value.displayName!);

                  //
                  AmitySocialClient.newPostRepository()
                      .getPostStream('9cf90cd06d874b8e72c7a0057a330de4')
                      .listen((event) {
                    log(event.toString());
                  }).onError((error, stackTrace) {
                    log('>>>>>' + error.message.toString());
                  });
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .getUsers()
                    .query()
                    .then((value) {
                  log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get All User'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .getUser('victimiOS')
                    .then((value) {
                  log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get User by ID'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .searchUserByDisplayName('sor')
                    .query()
                    .then((value) {
                  log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Search User by Display Name'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .user('87')
                    .follow()
                    .then((value) {
                  log('Follow 87');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Follow user 87'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .unfollow('87')
                    .then((value) {
                  log('Unfollow 87');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Unfollow user 87'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .accept('88')
                    .then((value) {
                  log('Accept 88');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Accept Follow Request 88'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .decline('88')
                    .then((value) {
                  log('Decline 88');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Decline Follow Request 88'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .getFollowInfo()
                    .then((value) {
                  log('Decline 88');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Follow Info me'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .user('87')
                    .getFollowInfo()
                    .then((value) {
                  log('Decline 88');
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Follow Info 87'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .getFollowers()
                    .query()
                    .then((value) {
                  log(value.toString());
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get my follower'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .me()
                    .getFollowings()
                    .query()
                    .then((value) {
                  log(value.toString());
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get my following'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .user('victimiOS')
                    .getFollowers()
                    .query()
                    .then((value) {
                  log(value.toString());
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get victimiOS followers'),
            ),
            TextButton(
              onPressed: () async {
                AmityCoreClient.newUserRepository()
                    .relationship()
                    .user('victimiOS')
                    .getFollowings()
                    .query()
                    .then((value) {
                  log(value.toString());
                  // log(value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log(error.message.toString());
                });
              },
              child: const Text('Get victimiOS following'),
            ),
            TextButton(
              onPressed: () async {
                AmitySocialClient.newPostRepository()
                    .getPost('9cf90cd06d874b8e72c7a0057a330de4')
                    .then((value) {
                  log('>>>>>' + value.toString());
                }).onError<AmityException>((error, stackTrace) {
                  log('>>>>>' + error.message.toString());
                });
              },
              child: const Text('Get Post'),
            ),
            TextButton(
              onPressed: () async {
                AmitySocialClient.newPostRepository()
                    .createPost()
                    .targetUser('victimiOS')
                    .text('Saurabh')
                    .post()
                    .then((value) {})
                    .onError<AmityException>((error, stackTrace) {
                  log('>>>>>' + error.message.toString());
                });
              },
              child: const Text('Create Text Post'),
            ),
            TextButton(
              onPressed: () async {
                AmitySocialClient.newCommentRepository()
                    .createComment()
                    .post('9cf90cd06d874b8e72c7a0057a330de4')
                    .create()
                    .text('Comment from Saurabh')
                    .send()
                    .then((value) {})
                    .onError<AmityException>((error, stackTrace) {
                  log('>>>>>' + error.message.toString());
                });
              },
              child: const Text('Create Comment For Post'),
            ),
            TextButton(
              onPressed: () async {
                AmitySocialClient.newCommentRepository()
                    .getComments()
                    .post('9cf90cd06d874b8e72c7a0057a330de4')
                    .parentId(null)
                    .query()
                    .then((value) {})
                    .onError<AmityException>((error, stackTrace) {
                  log('>>>>>' + error.message.toString());
                });
              },
              child: const Text('Get Comment For Post'),
            ),
            TextButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                AmityCoreClient.newFileRepository()
                    .image(File(image!.path))
                    .upload()
                    .then((value) {
                  if (value is AmityUploadComplete) {
                    AmitySocialClient.newPostRepository()
                        .createPost()
                        .targetUser('victimiOS')
                        .image([
                          (value as AmityUploadComplete).getFile as AmityImage
                        ])
                        .post()
                        .then((value) {
                          log('>>>>> ' + value.toString());
                        })
                        .onError<AmityException>((error, stackTrace) {
                          log('>>>>>' + error.message.toString());
                        });
                  }
                }).onError<AmityException>((error, stackTrace) {
                  log('>>>>>' + error.message.toString());
                });
              },
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }

  late PagingController _controller;
}
