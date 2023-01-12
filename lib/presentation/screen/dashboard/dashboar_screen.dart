import 'package:amity_sdk/amity_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return SafeArea(
      key: const Key('dashboard_screen_key'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.profile,
                        params: {'userId': AmityCoreClient.getUserId()});
                  },
                  child: const Text('User Profile'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.createPost,
                        params: {'userId': 'victimIOS'});
                  },
                  child: const Text('Create Post'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.globalFeed);
                  },
                  child: const Text('Global Feed'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.userFeed, params: {
                      'userId': AmityCoreClient.getCurrentUser().userId!
                    });
                  },
                  child: const Text('My Feed'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.userFeed,
                        params: {'userId': 'victimIOS'});
                  },
                  child: const Text('User Feed'),
                ),
                const SizedBox(height: 20),
                // TextButton(
                //   onPressed: () {
                //     GoRouter.of(context).goNamed(AppRoute.communityFeed,
                //         params: {
                //           'communityId': 'f5a99abc1f275df3f4259b6ca0e3cb15'
                //         });
                //   },
                //   child: const Text('Community Feed'),
                // ),
                // const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    EditTextDialog.show(
                      context,
                      hintText: 'Enter Comment Id',
                      onPress: (value) {
                        GoRouter.of(context).goNamed(AppRoute.postDetail,
                            params: {'postId': value});
                      },
                    );
                  },
                  child: const Text('Get Post'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.createPollPost);
                  },
                  child: const Text('Create Poll Post'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.communityMember,
                        params: {
                          'communityId': 'f5a99abc1f275df3f4259b6ca0e3cb15'
                        });
                  },
                  child: const Text('Community Members'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    FirebaseMessaging messaging = FirebaseMessaging.instance;

                    NotificationSettings settings =
                        await messaging.requestPermission();

                    if (settings.authorizationStatus ==
                        AuthorizationStatus.authorized) {
                      print('User granted permission');
                    } else if (settings.authorizationStatus ==
                        AuthorizationStatus.provisional) {
                      print('User granted provisional permission');
                    } else {
                      print('User declined or has not accepted permission');
                      return;
                    }

                    final token = await messaging.getToken();
                    AmityCoreClient.registerDeviceNotification(token!)
                        .then((value) {
                      PositiveDialog.show(context,
                          title: 'Success', message: token);
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  },
                  child: const Text('Register notification'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    AmityCoreClient.unregisterDeviceNotification()
                        .then((value) {
                      PositiveDialog.show(context,
                          title: 'Success',
                          message: 'Device Unregister Successfully');
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  },
                  child: const Text('Unregister notification'),
                ),
                // const SizedBox(height: 20),
                // TextButton(
                //   onPressed: () {
                //     AmitySocialClient.newCommunityRepository()
                //         .getCommunity('f5a99abc1f275df3f4259b6ca0e3cb15')
                //         .then((value) {
                //       print(value);
                //     }).onError((error, stackTrace) {
                //       print('Error' + error.toString());
                //     });
                //   },
                //   child: const Text(
                //       'Get Community Id - f5a99abc1f275df3f4259b6ca0e3cb15'),
                // ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.communityList);
                  },
                  child: const Text('Communities'),
                ),
                // const SizedBox(height: 20),
                // TextButton(
                //   onPressed: () {
                //     GoRouter.of(context).goNamed(AppRoute.createCommunity);
                //   },
                //   child: const Text('Create Community'),
                // ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .goNamed(AppRoute.communityTrendingList);
                  },
                  child: const Text('Trending Communities'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .goNamed(AppRoute.communityRecommendedList);
                  },
                  child: const Text('Recommended Communities'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.tokenExchange);
                  },
                  child: const Text('Token exchange'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    AmityChatClient.newMessageRepository()
                        .getMessages('prod23')
                        .stackFromEnd(true)
                        .getPagingData();
                    // GoRouter.of(context).goNamed(AppRoute.tokenExchange);
                  },
                  child: const Text('Messsage'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    EditTextDialog.show(context,
                        hintText: 'Enter Channel Name',
                        buttonText: 'Join', onPress: (value) {
                      GoRouter.of(context)
                          .goNamed(AppRoute.chat, params: {'channelId': value});
                    });
                  },
                  child: const Text('Chat Screen'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    EditTextDialog.show(context,
                        hintText: 'Enter Channel Name',
                        // defString: 'live200',
                        buttonText: 'Join', onPress: (value) {
                      GoRouter.of(context).pushNamed(AppRoute.channelProfile,
                          params: {'channelId': value});
                      // AmityChatClient.newChannelRepository().getChannel(value);
                    });
                  },
                  child: const Text('Get Channel'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRoute.channelList);
                  },
                  child: const Text('Channel List'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed(AppRoute.landing);
                  },
                  child: const Text('New Landing'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    AmityCoreClient.logout().then((value) {
                      GoRouter.of(context).goNamed(AppRoute.login);
                    });
                  },
                  child: Text(
                    'Logout',
                    style: _themeData.textTheme.subtitle1!
                        .copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
