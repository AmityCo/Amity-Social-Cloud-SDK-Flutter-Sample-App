import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_poll_post/create_poll_post_screen.dart';

class ChannelProfileScreen extends StatefulWidget {
  const ChannelProfileScreen({Key? key, required this.channelId})
      : super(key: key);
  final String channelId;
  @override
  State<ChannelProfileScreen> createState() => _ChannelProfileScreenState();
}

class _ChannelProfileScreenState extends State<ChannelProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AmityChannel _amityChannel;
  Future<AmityChannel>? _future;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _future =
        AmityChatClient.newChannelRepository().getChannel(widget.channelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final memberScreen = ChannelMembercreen(
    //   channelId: widget.channelId,
    //   showAppBar: false,
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Profile'),
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
                //Open Edit Channel
                // GoRouter.of(context).goNamed(AppRoute.updateChannel,
                //     params: {'channelId': widget.channelId});
              }
              if (index == 2) {
                //Delete Channel
                // AmitySocialClient.newChannelRepository()
                //     .deleteChannel(widget.channelId);
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
                    // final hasPermission =
                    //     AmityCoreClient.hasPermission(permissions.first)
                    //         .atChannel(widget.channelId)
                    //         .check();
                    // PositiveDialog.show(context,
                    //     title: 'Permission',
                    //     message:
                    //         'The permission "$value" is valid = $hasPermission');
                  }
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<AmityChannel>(
        future: _future,
        builder: (context, futureSnapshot) {
          if (futureSnapshot.hasData) {
            _amityChannel = futureSnapshot.data!;
            return StreamBuilder<AmityChannel>(
                stream: _amityChannel.listen.stream,
                initialData: _amityChannel,
                builder: (context, snapshot) {
                  _amityChannel = snapshot.data!;
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: _ChannelProfileHeaderWidget(
                              amityChannel: _amityChannel),
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
                        // ChannelFeedScreen(
                        //     channelId: widget.channelId, showAppBar: false),
                        // memberScreen,
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
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Please Select Post Type'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //show create post for community
                          // GoRouter.of(context).goNamed(
                          //     AppRoute.createChannelPostPost,
                          //     params: {'channelId': widget.channelId});
                        },
                        child: const Text('Post'),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          //show create post for community
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) {
                          //     return CreatePollPostScreen(
                          //         channelId: widget.channelId);
                          //   },
                          // ));
                        },
                        child: const Text('Poll Post'),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(onPressed: () {}, child: const Text('Cancel'))
                ],
              ),
            );
          } else {
            //show add member action
            EditTextDialog.show(context,
                title: 'Add Member',
                hintText: 'Enter Comma seperated user Ids', onPress: (value) {
              // AmitySocialClient.newChannelRepository()
              //     .membership(widget.channelId)
              //     .addMembers(value.split(','))
              //     .then((value) {
              //   memberScreen.screenState.addMembers(value);
              // }).onError((error, stackTrace) {
              //   ErrorDialog.show(context,
              //       title: 'Error', message: error.toString());
              // });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChannelProfileHeaderWidget extends StatelessWidget {
  const _ChannelProfileHeaderWidget({Key? key, required this.amityChannel})
      : super(key: key);
  final AmityChannel amityChannel;
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
                    amityChannel.avatar?.getUrl(AmityImageSize.MEDIUM) != null
                        ? Image.network(
                            amityChannel.avatar!.getUrl(AmityImageSize.MEDIUM),
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
                            text: '${amityChannel.messageCount}\n',
                            style: _themeData.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'Messages',
                              style: _themeData.textTheme.bodyText2),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${amityChannel.memberCount}\n',
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
            amityChannel.displayName ?? '',
            style: _themeData.textTheme.headline6,
          ),
          // const SizedBox(height: 8),
          // Text(
          //   amityChannel.description ?? '',
          //   style: _themeData.textTheme.caption,
          // ),
          // const SizedBox(height: 18),
          // FutureBuilder<List<String>>(
          //   future: amityChannel.getCurentUserRoles(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Text('Rolse - ${snapshot.data!.join(',')}');
          //     }
          //     if (snapshot.hasError) {
          //       // print(snapshot.error.toString());
          //     }
          //     return Container();
          //   },
          // ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: () {
                  // if (!(amityChannel.isJoined ?? true)) {
                  //   AmitySocialClient.newChannelRepository()
                  //       .joinChannel(amityChannel.channelId!)
                  //       .then((value) {})
                  //       .onError((error, stackTrace) {
                  //     ErrorDialog.show(context,
                  //         title: 'Error', message: error.toString());
                  //   });
                  // } else {
                  //   AmitySocialClient.newChannelRepository()
                  //       .leaveChannel(amityChannel.channelId!)
                  //       .then((value) {})
                  //       .onError((error, stackTrace) {
                  //     ErrorDialog.show(context,
                  //         title: 'Error', message: error.toString());
                  //   });
                  // }
                },
                child: const Text('Join'),
              ),
            ),
          ),
          // if (amityChannel
          //         .hasPermission(AmityPermission.REVIEW_COMMUNITY_POST) &&
          //     amityChannel.isPostReviewEnabled!)
          //   Center(
          //     child: SizedBox(
          //       width: 260,
          //       child: ElevatedButton(
          //         onPressed: () {
          //           GoRouter.of(context).pushNamed(
          //               AppRoute.communityInReviewPost,
          //               params: {'channelId': amityChannel.channelId!});
          //         },
          //         child: const Text('Review Post'),
          //       ),
          //     ),
          //   )
          // else
          //   Center(
          //     child: SizedBox(
          //       width: 260,
          //       child: ElevatedButton(
          //         onPressed: () {
          //           GoRouter.of(context).pushNamed(
          //               AppRoute.communityPendingPost,
          //               params: {'channelId': amityChannel.channelId!});
          //         },
          //         child: const Text('Pending Post'),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
