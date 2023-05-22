import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/channel_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';

class ChannelMemberBannedScreen extends StatefulWidget {
  const ChannelMemberBannedScreen(
      {Key? key, required this.channelId, this.showAppBar = true})
      : super(key: key);
  final String channelId;
  final bool showAppBar;
  @override
  State<ChannelMemberBannedScreen> createState() =>
      _ChannelMemberBannedScreenState();
}

class _ChannelMemberBannedScreenState extends State<ChannelMemberBannedScreen> {
  late PagingController<AmityChannelMember> _controller;
  final amityChannelMembers = <AmityChannelMember>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .membership(widget.channelId)
          .getMembers()
          .filter(AmityChannelMembershipFilter.BANNED)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            if (mounted) {
              setState(() {
                amityChannelMembers.clear();
                amityChannelMembers.addAll(_controller.loadedItems);
              });
            }
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context,
                title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void addMembers(List<AmityChannelMember> members) {
    _controller.addAll(members);
  }

  void removeMembers(List<String> userIds) {
    _controller.removeWhere((member) => userIds.contains(member.userId));
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: Text('Channel Members - ${widget.channelId}'))
          : null,
      body: Column(
        children: [
          Expanded(
            child: amityChannelMembers.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollcontroller,
                      itemCount: amityChannelMembers.length,
                      itemBuilder: (context, index) {
                        final amityChannelMember = amityChannelMembers[index];
                        return ChannelMemberWidget(
                          amityChannelMember: amityChannelMember,
                          onMemberCallback: () {},
                          options: [
                            PopupMenuButton(
                              itemBuilder: (context) {
                                final isMemberBanned =
                                    amityChannelMember.isBanned ?? false;

                                final canRemoveMember =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.REMOVE_CHANNEL_USER)
                                        .atChannel(
                                            amityChannelMember.channelId!)
                                        .check();

                                final canBanMember = AmityCoreClient
                                        .hasPermission(AmityPermission
                                            .BAN_USER_FROM_CHANNEL)
                                    .atChannel(amityChannelMember.channelId!)
                                    .check();

                                final canAddRole =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.CREATE_ROLE)
                                        .atChannel(
                                            amityChannelMember.channelId!)
                                        .check();

                                final canRemoveRole =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.DELETE_ROLE)
                                        .atChannel(
                                            amityChannelMember.channelId!)
                                        .check();

                                final canMuteRole = AmityCoreClient
                                        .hasPermission(AmityPermission
                                            .MUTE_USER_INSIDE_CHANNEL)
                                    .atChannel(amityChannelMember.channelId!)
                                    .check();
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    enabled: canRemoveMember,
                                    child: const Text("Remove"),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    enabled: canBanMember && !isMemberBanned,
                                    child: const Text("Ban"),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    enabled: canBanMember && isMemberBanned,
                                    child: const Text("Unban"),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    enabled: canAddRole && !isMemberBanned,
                                    child: const Text("Add role"),
                                  ),
                                  PopupMenuItem(
                                    value: 5,
                                    enabled: canRemoveRole && !isMemberBanned,
                                    child: const Text("Remove role"),
                                  ),
                                  const PopupMenuItem(
                                    value: 6,
                                    child: Text("Check Permission"),
                                  ),
                                  PopupMenuItem(
                                    value: 7,
                                    enabled: canMuteRole,
                                    child: const Text("Mute"),
                                  )
                                ];
                              },
                              child: const Icon(
                                Icons.more_vert,
                                size: 18,
                              ),
                              onSelected: (index) {
                                if (index == 1) {
                                  // _removeMember(context, amityChannelMember);
                                }
                                if (index == 2) {
                                  _banMember(context, amityChannelMember);
                                }
                                if (index == 3) {
                                  _unbanMember(context, amityChannelMember);
                                }
                                if (index == 4) {
                                  _addRole(context, amityChannelMember);
                                }
                                if (index == 5) {
                                  _removeRole(context, amityChannelMember);
                                }
                                if (index == 6) {
                                  EditTextDialog.show(context,
                                      title: 'Enter valid permission string',
                                      defString: 'ADD_CHANNEL_USER',
                                      hintText: 'permisson', onPress: (value) {
                                    try {
                                      AmityPermission permission =
                                          AmityPermissionExtension.enumOf(
                                              value);
                                      final havePermission = AmityCoreClient
                                              .hasPermission(permission)
                                          .atChannel(
                                              amityChannelMember.channelId!,
                                              userId: amityChannelMember.userId)
                                          .check();
                                      if (havePermission) {
                                        CommonSnackbar.showPositiveSnackbar(
                                            context,
                                            'Permission',
                                            'User have this permission');
                                      } else {
                                        CommonSnackbar.showNagativeSnackbar(
                                            context,
                                            'Permission',
                                            'User dont have this permission');
                                      }
                                    } catch (error) {
                                      CommonSnackbar.showNagativeSnackbar(
                                          context,
                                          'Error Permission',
                                          'Error in performing permission check ${error.toString()}');
                                    }
                                  });
                                }

                                if (index == 7) {
                                  _muteMember(context, amityChannelMember);
                                }
                              },
                            )
                          ],
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Members'),
                  ),
          ),
          if (_controller.isFetching && amityChannelMembers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  void _muteMember(BuildContext context, AmityChannelMember member) {
    AmityChatClient.newChannelRepository()
        .moderation(member.channelId!)
        .muteMembers([member.userId!])
        .then((value) => PositiveDialog.show(context,
            title: 'Complete', message: 'Mute member successfully'))
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            });
  }

  // void _removeMember(BuildContext context, AmityChannelMember member) {
  //   AmitySocialClient.newChannelRepository()
  //       .membership(member.channelId!)
  //       .removeMembers([member.userId!])
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           })
  //       .then((value) => {
  //             removeMembers([member.userId!])
  //           });
  // }

  void _banMember(BuildContext context, AmityChannelMember value) {
    AmityChatClient.newChannelRepository()
        .moderation(value.channelId!)
        .banMembers([value.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) {
          _controller.reset();
          _controller.fetchNextPage();
          PositiveDialog.show(context,
              title: 'Complete', message: 'Member banned successfully');
        });
  }

  void _unbanMember(BuildContext context, AmityChannelMember value) {
    AmityChatClient.newChannelRepository()
        .moderation(value.channelId!)
        .unbanMembers([value.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) {
          _controller.reset();
          _controller.fetchNextPage();
          PositiveDialog.show(context,
              title: 'Complete', message: 'Member unbanned successfully');
        });
  }

  void _addRole(BuildContext context, AmityChannelMember member) {
    AmityChatClient.newChannelRepository()
        .moderation(member.channelId!)
        .addRole('channel-moderator', [member.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) {
          PositiveDialog.show(context,
              title: 'Complete', message: 'Role added successfully');
          // AmityChatClient.newChannelRepository()
          //     .moderation(member.channelId!)
          //     .addRole('channel-moderator', [member.userId!]).then(
          //         (value) => {
          //               PositiveDialog.show(context,
          //                   title: 'Complete',
          //                   message: 'Role added successfully')
          //             })
        });
  }

  void _removeRole(BuildContext context, AmityChannelMember member) {
    AmityChatClient.newChannelRepository()
        .moderation(member.channelId!)
        .removeRole('channel-moderator', [member.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) {
          PositiveDialog.show(context,
              title: 'Complete', message: 'Role removed successfully');
          // AmityChatClient.newChannelRepository()
          //     .moderation(member.channelId!)
          //     .removeRole('channel-moderator', [member.userId!]).then(
          //         (value) => {

          //             })
        });
  }
}
