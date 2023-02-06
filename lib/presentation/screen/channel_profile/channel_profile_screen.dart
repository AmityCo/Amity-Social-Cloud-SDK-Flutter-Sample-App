import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_member/channel_member_banned_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_member/channel_member_screen.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
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
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Channel Profile'),
                      actions: [
                        IconButton(
                          onPressed: () {
                            ///Mute/Unmute Channel
                            if (_amityChannel.isMuted ?? false) {
                              AmityChatClient.newChannelRepository()
                                  .unMuteChannel(widget.channelId);
                            } else {
                              AmityChatClient.newChannelRepository()
                                  .muteChannel(widget.channelId);
                            }
                          },
                          icon: Icon(
                            ((_amityChannel.isMuted ?? false)
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded),
                          ),
                        ),
                        IconButton(
                          key: const Key('send_message_btn'),
                          onPressed: () {
                            GoRouter.of(context).pushNamed(AppRoute.chat,
                                params: {'channelId': widget.channelId});
                          },
                          icon: const Icon(
                            Icons.mark_unread_chat_alt_outlined,
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 1,
                                child: Text("Edit"),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text("Delete (Soft)"),
                              ),
                              const PopupMenuItem(
                                value: 3,
                                enabled: false,
                                child: Text("Delete (Hard)"),
                              ),
                              const PopupMenuItem(
                                value: 4,
                                enabled: true,
                                child: Text("Check my permission"),
                              ),
                              PopupMenuItem(
                                value: 5,
                                child: Text((_amityChannel.isMuted ?? false)
                                    ? 'Unmute'
                                    : 'Mute'),
                              ),
                            ];
                          },
                          child: const Icon(
                            Icons.more_vert,
                            size: 18,
                          ),
                          onSelected: (index) {
                            if (index == 1) {
                              //Open Edit Channel
                              GoRouter.of(context).pushNamed(
                                  AppRoute.updateChannel,
                                  queryParams: {'channelId': widget.channelId});
                            }
                            if (index == 2) {
                              //Delete Channel
                              // AmitySocialClient.newChannelRepository()
                              //     .deleteChannel(widget.channelId);
                            }
                            if (index == 4) {
                              EditTextDialog.show(context,
                                  title:
                                      'Check my permission in this community',
                                  hintText: 'Enter permission name',
                                  onPress: (value) {
                                final permissions = AmityPermission.values
                                    .where((v) => v.value == value);

                                if (permissions.isEmpty) {
                                  ErrorDialog.show(context,
                                      title: 'Error',
                                      message: 'permission does not exist');
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
                            if (index == 5) {
                              ///Mute/Unmute Channel
                              if (_amityChannel.isMuted ?? false) {
                                AmityChatClient.newChannelRepository()
                                    .unMuteChannel(widget.channelId);
                              } else {
                                AmityChatClient.newChannelRepository()
                                    .muteChannel(widget.channelId);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    body: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: _ChannelProfileHeaderWidget(
                                amityChannel: _amityChannel),
                          ),
                          SliverToBoxAdapter(
                            child: DefaultTabController(
                              length: 1,
                              child: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(
                                    text: 'Members',
                                  ),
                                  Tab(
                                    text: 'Banned Members',
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
                          // Container(),
                          ChannelMemberScreen(
                            channelId: widget.channelId,
                            showAppBar: false,
                          ),
                          ChannelMemberBannedScreen(
                            channelId: widget.channelId,
                            showAppBar: false,
                          ),
                          // ChannelFeedScreen(
                          //     channelId: widget.channelId, showAppBar: false),
                          // memberScreen,
                        ],
                      ),
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
          //show add member action
          EditTextDialog.show(context,
              title: 'Add Channel Member',
              hintText: 'Enter Comma seperated user Ids', onPress: (value) {
            AmityChatClient.newChannelRepository()
                .addMembers(_amityChannel.channelId!, value.split(','))
                .then((value) {
              // memberScreen.screenState.addMembers(value);
            }).onError((error, stackTrace) {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString());
            });
          });
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
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child:
                    amityChannel.avatar?.getUrl(AmityImageSize.MEDIUM) != null
                        ? Image.network(
                            amityChannel.avatar!.getUrl(AmityImageSize.MEDIUM),
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/user_placeholder.png'),
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
          const SizedBox(height: 6),
          SelectableText(
            amityChannel.channelId ?? '',
            style: _themeData.textTheme.subtitle1,
          ),
          const SizedBox(height: 8),
          const Text('Current User Roles & Permission'),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: amityChannel.getCurentUserRoles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Roles - ${snapshot.data!.join(',')}');
              }
              if (snapshot.hasError) {
                // print(snapshot.error.toString());
              }
              return Container();
            },
          ),
          const SizedBox(height: 8),
          Text('isMute - ${amityChannel.isMuted ?? false}'),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: amityChannel.getCurentUserPermission(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Permission - ${snapshot.data!.join(',')}');
              }
              if (snapshot.hasError) {
                // print(snapshot.error.toString());
              }
              return Container();
            },
          ),
          const SizedBox(height: 18),
          FutureBuilder<AmityChannelMember>(
              future: AmityChatClient.newChannelRepository()
                  .membership(amityChannel.channelId!)
                  .getMyMembership(),
              builder: (context, snapshot) {
                final amityChannelMember = snapshot.data;
                if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 260,
                      child: ElevatedButton(
                        onPressed: () {
                          if (amityChannelMember!.membership ==
                              AmityMembershipType.NONE) {
                            AmityChatClient.newChannelRepository()
                                .joinChannel(amityChannel.channelId!)
                                .then((value) {})
                                .onError((error, stackTrace) {
                              ErrorDialog.show(context,
                                  title: 'Error', message: error.toString());
                            });
                          } else {
                            AmityChatClient.newChannelRepository()
                                .leaveChannel(amityChannel.channelId!)
                                .then((value) {})
                                .onError((error, stackTrace) {
                              ErrorDialog.show(context,
                                  title: 'Error', message: error.toString());
                            });
                          }
                        },
                        child: Text(amityChannelMember!.membership ==
                                AmityMembershipType.NONE
                            ? 'Join'
                            : 'Leave'),
                      ),
                    ),
                  );
                }

                return Container();
              }),
        ],
      ),
    );
  }
}
