import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/amity_user_info_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class GlobalUserSearch extends StatefulWidget {
  const GlobalUserSearch({Key? key, this.showAppBar = true}) : super(key: key);
  final bool showAppBar;
  @override
  State<GlobalUserSearch> createState() => _GlobalUserSearchState();
}

class _GlobalUserSearchState extends State<GlobalUserSearch> {
  late PagingController<AmityUser> _controller;
  final amityUsers = <AmityUser>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyword = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityUserSortOption _sort = AmityUserSortOption.DISPLAY;
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .searchUserByDisplayName(_keyword)
          .sortBy(_sort)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            if (mounted) {
              setState(() {
                amityUsers.clear();
                amityUsers.addAll(_controller.loadedItems);
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

  // void addMembers(List<AmityChannelMember> members) {
  //   _controller.addAll(members);
  // }

  // void removeMembers(List<String> userIds) {
  //   _controller.removeWhere((member) => userIds.contains(member.userId));
  // }

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
          ? AppBar(title: const Text('Global User Search'))
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: TextFormField(
              onChanged: (value) {
                _debouncer.run(() {
                  _keyword = value;
                  _controller.reset();
                  _controller.fetchNextPage();
                });
              },
              decoration: const InputDecoration(hintText: 'Enter Keybaord'),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        child: Text(AmityUserSortOption.DISPLAY.name),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(AmityUserSortOption.FIRST_CREATED.name),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(AmityUserSortOption.LAST_CREATED.name),
                      )
                    ];
                  },
                  child: const Icon(
                    Icons.filter_alt_rounded,
                    size: 18,
                  ),
                  onSelected: (index) {
                    if (index == 1) {
                      _sort = AmityUserSortOption.DISPLAY;
                    }
                    if (index == 2) {
                      _sort = AmityUserSortOption.FIRST_CREATED;
                    }
                    if (index == 3) {
                      _sort = AmityUserSortOption.LAST_CREATED;
                    }

                    _controller.reset();
                    _controller.fetchNextPage();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: amityUsers.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollcontroller,
                      itemCount: amityUsers.length,
                      itemBuilder: (context, index) {
                        final amityUser = amityUsers[index];
                        return AmityUserInfoWidget(
                          amityUser: amityUser,
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
          if (_controller.isFetching && amityUsers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  // void _muteMember(BuildContext context, AmityChannelMember member) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(member.channelId!)
  //       .muteMembers([member.userId!])
  //       .then((value) => PositiveDialog.show(context,
  //           title: 'Complete', message: 'Mute member successfully'))
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           });
  // }

  // void _permanentMuteMember(BuildContext context, AmityChannelMember member) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(member.channelId!)
  //       .muteMembers([member.userId!], millis: -1)
  //       .then((value) => PositiveDialog.show(context,
  //           title: 'Complete', message: 'Mute member successfully'))
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           });
  // }

  // void _unMuteMember(BuildContext context, AmityChannelMember member) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(member.channelId!)
  //       .muteMembers([member.userId!], millis: 0)
  //       .then((value) => PositiveDialog.show(context,
  //           title: 'Complete', message: 'Un-Mute member successfully'))
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           });
  // }

  // // void _removeMember(BuildContext context, AmityChannelMember member) {
  // //   AmitySocialClient.newChannelRepository()
  // //       .membership(member.channelId!)
  // //       .removeMembers([member.userId!])
  // //       .onError((error, stackTrace) => {
  // //             ErrorDialog.show(context,
  // //                 title: 'Error', message: error.toString())
  // //           })
  // //       .then((value) => {
  // //             removeMembers([member.userId!])
  // //           });
  // // }

  // void _banMember(BuildContext context, AmityChannelMember value) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(value.channelId!)
  //       .banMembers([value.userId!])
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           })
  //       .then((value) {
  //         _controller.reset();
  //         _controller.fetchNextPage();
  //         PositiveDialog.show(context,
  //             title: 'Complete', message: 'Member banned successfully');
  //       });
  // }

  // void _unbanMember(BuildContext context, AmityChannelMember value) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(value.channelId!)
  //       .unbanMembers([value.userId!])
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           })
  //       .then((value) {
  //         _controller.reset();
  //         _controller.fetchNextPage();
  //         PositiveDialog.show(context,
  //             title: 'Complete', message: 'Member unbanned successfully');
  //       });
  // }

  // void _addRole(BuildContext context, AmityChannelMember member) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(member.channelId!)
  //       .addRole('channel-moderator', [member.userId!])
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           })
  //       .then((value) {
  //         PositiveDialog.show(context,
  //             title: 'Complete', message: 'Role added successfully');
  //         // AmityChatClient.newChannelRepository()
  //         //     .moderation(member.channelId!)
  //         //     .addRole('channel-moderator', [member.userId!]).then(
  //         //         (value) => {
  //         //               PositiveDialog.show(context,
  //         //                   title: 'Complete',
  //         //                   message: 'Role added successfully')
  //         //             })
  //       });
  // }

  // void _removeRole(BuildContext context, AmityChannelMember member) {
  //   AmityChatClient.newChannelRepository()
  //       .moderation(member.channelId!)
  //       .removeRole('channel-moderator', [member.userId!])
  //       .onError((error, stackTrace) => {
  //             ErrorDialog.show(context,
  //                 title: 'Error', message: error.toString())
  //           })
  //       .then((value) {
  //         PositiveDialog.show(context,
  //             title: 'Complete', message: 'Role removed successfully');
  //         // AmityChatClient.newChannelRepository()
  //         //     .moderation(member.channelId!)
  //         //     .removeRole('channel-moderator', [member.userId!]).then(
  //         //         (value) => {

  //         //             })
  //       });
  // }
}
