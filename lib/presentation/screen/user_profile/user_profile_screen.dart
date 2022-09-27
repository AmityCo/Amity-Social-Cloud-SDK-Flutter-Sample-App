import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_post/create_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_feed/user_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_post/user_post_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  XFile? _avatar;

  AmityUser? _amityUser;

  late bool _isOwnerProfile;

  late Future<AmityUser> _future;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _future = AmityCoreClient.newUserRepository().getUser(widget.userId);

    _isOwnerProfile = AmityCoreClient.getUserId() == widget.userId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: FutureBuilder<AmityUser>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              final amityUser = snapshot.data;
              _amityUser = amityUser;
              return Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            // Pick an image
                            final image = await _picker.pickImage(
                                source: ImageSource.gallery);

                            setState(() {
                              _avatar = image;
                            });

                            ProgressDialog.show(
                              context,
                              asyncFunction: _updateAvatar,
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(.3)),
                            child: _avatar != null
                                ? Image.file(
                                    File(
                                      _avatar!.path,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : amityUser!.avatarUrl != null
                                    ? Image.network(
                                        amityUser.avatarUrl!,
                                        fit: BoxFit.fill,
                                      )
                                    : amityUser.avatarCustomUrl != null
                                        ? Image.network(
                                            amityUser.avatarCustomUrl!,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(
                                            'assets/user_placeholder.png'),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${amityUser!.userId}',
                                style: _themeData.textTheme.headline5!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              _isOwnerProfile
                                  ? FutureBuilder<AmityMyFollowInfo>(
                                      future: amityUser.me().getFollowInfo(),
                                      builder: (context, snapshot) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    GoRouter.of(context)
                                                        .goNamed(
                                                            AppRoute
                                                                .followersMy,
                                                            params: {
                                                          'userId':
                                                              widget.userId
                                                        });
                                                  },
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Followers\n',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        ),
                                                        TextSpan(
                                                          text: snapshot.hasData
                                                              ? '${snapshot.data!.followerCount}'
                                                              : '0',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    GoRouter.of(context)
                                                        .goNamed(
                                                            AppRoute
                                                                .followingsMy,
                                                            params: {
                                                          'userId':
                                                              widget.userId
                                                        });
                                                  },
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Following\n',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        ),
                                                        TextSpan(
                                                          text: snapshot.hasData
                                                              ? '${snapshot.data!.followingCount}'
                                                              : '0',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    GoRouter.of(context).goNamed(
                                                        AppRoute
                                                            .followersPendingMy,
                                                        params: {
                                                          'userId':
                                                              widget.userId
                                                        });
                                                  },
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Pending\n',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        ),
                                                        TextSpan(
                                                          text: snapshot.hasData
                                                              ? '${snapshot.data!.pendingRequestCount}'
                                                              : '0',
                                                          style: _themeData
                                                              .textTheme
                                                              .subtitle1,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 160,
                                              margin: const EdgeInsets.only(
                                                  top: 12),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child:
                                                    const Text('Edit Profile'),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : FutureBuilder<AmityUserFollowInfo>(
                                      future: amityUser
                                          .relationship()
                                          .getFollowInfo(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }
                                        return StreamBuilder<
                                                AmityUserFollowInfo>(
                                            initialData: snapshot.data,
                                            stream:
                                                snapshot.data!.listen.stream,
                                            builder: (context, snapshot) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          GoRouter.of(context)
                                                              .goNamed(
                                                                  AppRoute
                                                                      .followersUser,
                                                                  params: {
                                                                'userId': widget
                                                                    .userId
                                                              });
                                                        },
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Followers\n',
                                                                style: _themeData
                                                                    .textTheme
                                                                    .subtitle1,
                                                              ),
                                                              TextSpan(
                                                                text: snapshot
                                                                        .hasData
                                                                    ? '${snapshot.data!.followerCount}'
                                                                    : '0',
                                                                style: _themeData
                                                                    .textTheme
                                                                    .subtitle1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          GoRouter.of(context)
                                                              .goNamed(
                                                                  AppRoute
                                                                      .followingsUser,
                                                                  params: {
                                                                'userId': widget
                                                                    .userId
                                                              });
                                                        },
                                                        child: RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Following\n',
                                                                style: _themeData
                                                                    .textTheme
                                                                    .subtitle1,
                                                              ),
                                                              TextSpan(
                                                                text: snapshot
                                                                        .hasData
                                                                    ? '${snapshot.data!.followingCount}'
                                                                    : '0',
                                                                style: _themeData
                                                                    .textTheme
                                                                    .subtitle1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 160,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 12),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (snapshot.hasData) {
                                                          if (snapshot.data!
                                                                  .status ==
                                                              AmityFollowStatus
                                                                  .NONE) {
                                                            amityUser
                                                                .relationship()
                                                                .follow();
                                                          } else {
                                                            amityUser
                                                                .relationship()
                                                                .unfollow();
                                                          }
                                                        }
                                                      },
                                                      child: Text(snapshot
                                                              .hasData
                                                          ? snapshot.data!
                                                                      .status ==
                                                                  AmityFollowStatus
                                                                      .ACCEPTED
                                                              ? 'Unfollow'
                                                              : snapshot.data!
                                                                          .status ==
                                                                      AmityFollowStatus
                                                                          .PENDING
                                                                  ? 'Cancel Request'
                                                                  : 'Follow'
                                                          : 'Follow'),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Display name - ${amityUser.displayName}',
                      style: _themeData.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text('Description - ${amityUser.description}'),
                    const SizedBox(height: 8),
                    Text('Created Date - ${amityUser.createdAt}'),
                    const SizedBox(height: 8),
                    Text('Updated Date - ${amityUser.updatedAt}'),
                    const SizedBox(height: 8),
                    Text('Meta Data - ${amityUser.metadata}'),
                    const SizedBox(height: 8),
                    DefaultTabController(
                      length: 2,
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            text: 'Feed',
                          ),
                          Tab(
                            text: 'Post',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        UserFeedScreen(
                            userId: amityUser.userId!, showAppBar: false),
                        UserPostScreen(
                            userId: amityUser.userId!, showAppBar: false),
                      ]),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreatePostScreen(
                  userId: widget.userId,
                ),
              ),
            );
          },
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Future _updateAvatar() async {
    AmityImage? _userAvatar;
    if (_avatar != null) {
      AmityUploadResult<AmityImage> amityUploadResult =
          await AmityCoreClient.newFileRepository()
              .image(File(_avatar!.path))
              .upload();
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        _userAvatar = amityUploadComplete.getFile as AmityImage;
      }
    }

    await _amityUser!.update().avatarFileId(_userAvatar!.fileId).update();
  }
}
