import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_feed/community_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_member/community_member_screen.dart';
import 'package:go_router/go_router.dart';

class CommunityProfileScreen extends StatefulWidget {
  const CommunityProfileScreen({Key? key, required this.communityId})
      : super(key: key);
  final String communityId;
  @override
  State<CommunityProfileScreen> createState() => _CommunityProfileScreenState();
}

class _CommunityProfileScreenState extends State<CommunityProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AmityCommunity _amityCommunity;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final memberScreen = CommunityMembercreen(
      communityId: widget.communityId,
      showAppBar: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Profile'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text("Edit"),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("Delete (Soft)"),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text("Delete (Hard)"),
                  value: 3,
                  enabled: false,
                ),
                PopupMenuItem(
                  child: Text("Check my permission"),
                  value: 4,
                  enabled: true,
                )
              ];
            },
            child: const Icon(
              Icons.more_vert,
              size: 18,
            ),
            onSelected: (index) {
              if (index == 1) {
                //Open Edit Community
                GoRouter.of(context).goNamed(AppRoute.updateCommunity,
                    params: {'communityId': widget.communityId});
              }
              if (index == 2) {
                //Delete Community
                AmitySocialClient.newCommunityRepository()
                    .deleteCommunity(widget.communityId);
              }
              if (index == 4) {
                EditTextDialog.show(context,
                    title: 'Check my permission in this community',
                    hintText: 'Enter permission name', onPress: (value) {
                  final permissions =
                      AmityPermission.values.where((v) => v.value == value);

                  if (permissions.isEmpty) {
                    ErrorDialog.show(context,
                        title: 'Error', message: 'permission does not exist');
                  } else {
                    final hasPermission =
                        AmityCoreClient.hasPermission(permissions.first)
                            .atCommunity(widget.communityId)
                            .check();
                    PositiveDialog.show(context,
                        title: 'Permission',
                        message:
                            'The permission "$value" is valid = $hasPermission');
                  }
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<AmityCommunity>(
        future: AmitySocialClient.newCommunityRepository()
            .getCommunity(widget.communityId),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.hasData) {
            _amityCommunity = futureSnapshot.data!;
            return StreamBuilder<AmityCommunity>(
                stream: _amityCommunity.listen,
                initialData: _amityCommunity,
                builder: (context, snapshot) {
                  _amityCommunity = snapshot.data!;
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: _CommunityProfileHeaderWidget(
                              amityCommunity: _amityCommunity),
                        ),
                        SliverToBoxAdapter(
                          child: DefaultTabController(
                            length: 2,
                            child: TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(
                                  text: 'Feed',
                                ),
                                Tab(
                                  text: 'Members',
                                )
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CommunityFeedScreen(
                            communityId: widget.communityId, showAppBar: false),
                        memberScreen,
                      ],
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            //show create post for community
            ErrorDialog.show(context, title: 'Error', message: 'Not Supported');
          } else {
            //show add member action
            EditTextDialog.show(context,
                title: 'Add Member',
                hintText: 'Enter Comma seperated user Ids', onPress: (value) {
              AmitySocialClient.newCommunityRepository()
                  .membership(widget.communityId)
                  .addMembers(value.split(','))
                  .then((value) {
                memberScreen.screenState.addMembers(value);
              }).onError((error, stackTrace) {
                ErrorDialog.show(context,
                    title: 'Error', message: error.toString());
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CommunityProfileHeaderWidget extends StatelessWidget {
  const _CommunityProfileHeaderWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                child:
                    amityCommunity.avatarImage?.getUrl(AmityImageSize.MEDIUM) !=
                            null
                        ? Image.network(
                            amityCommunity.avatarImage!
                                .getUrl(AmityImageSize.MEDIUM),
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/user_placeholder.png'),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${amityCommunity.postsCount}\n',
                            style: _themeData.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'Posts',
                              style: _themeData.textTheme.bodyText2),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${amityCommunity.membersCount}\n',
                            style: _themeData.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'Members',
                              style: _themeData.textTheme.bodyText2),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amityCommunity.displayName ?? '',
            style: _themeData.textTheme.headline6,
          ),
          const SizedBox(height: 8),
          Text(
            amityCommunity.description ?? '',
            style: _themeData.textTheme.caption,
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<String>>(
            future: amityCommunity.getCurentUserRoles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Rolse - ${snapshot.data!.join(',')}');
              }
              if (snapshot.hasError) {
                // print(snapshot.error.toString());
              }
              return Container();
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: () {
                  if (!(amityCommunity.isJoined ?? true)) {
                    AmitySocialClient.newCommunityRepository()
                        .joinCommunity(amityCommunity.communityId!)
                        .then((value) {})
                        .onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  } else {
                    AmitySocialClient.newCommunityRepository()
                        .leaveCommunity(amityCommunity.communityId!)
                        .then((value) {})
                        .onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  }
                },
                child:
                    Text(!(amityCommunity.isJoined ?? true) ? 'Join' : 'Leave'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
