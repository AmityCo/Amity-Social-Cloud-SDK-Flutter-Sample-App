import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_post/create_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_post/user_post_screen.dart';

import '../user_feed/user_feed_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
          future: AmityCoreClient.newUserRepository().getUser(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // ErrorDialog.show(context,
              //     title: 'Error', message: snapshot.error.toString());
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              final amityUser = snapshot.data;
              return Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(.3)),
                          child: amityUser!.avatarCustomUrl != null
                              ? Image.network(
                                  amityUser.avatarCustomUrl!,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset('assets/user_placeholder.png'),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${amityUser.userId}',
                          style: _themeData.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold),
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
}
