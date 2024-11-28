import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/amity_user_info_widget.dart';

class GlobalUserSearch extends StatefulWidget {
  const GlobalUserSearch({Key? key, this.showAppBar = true}) : super(key: key);
  final bool showAppBar;
  @override
  State<GlobalUserSearch> createState() => _GlobalUserSearchState();
}

class _GlobalUserSearchState extends State<GlobalUserSearch> {
  late UserLiveCollection _userLiveCollection;
  List<AmityUser> amityUsers = <AmityUser>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyword = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityUserSortOption _sort = AmityUserSortOption.DISPLAY;
  @override
  void initState() {
    resetLiveCollection(isReset: false);
    scrollcontroller.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels == scrollcontroller.position.maxScrollExtent)
      && _userLiveCollection.hasNextPage()) {
        _userLiveCollection.loadNext();
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
                  resetLiveCollection();
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
                    resetLiveCollection();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: amityUsers.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      resetLiveCollection();
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
                    child: _userLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Members'),
                  ),
          ),
          if (_userLiveCollection.isFetching && amityUsers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  void resetLiveCollection({ bool isReset = true }) async {
    if (isReset) {
      _userLiveCollection.getStreamController().close();
      setState(() {
        amityUsers = [];
      });
    }

    _userLiveCollection = AmityCoreClient.newUserRepository()
      .searchUserByDisplayName(_keyword)
      .sortBy(_sort)
      .getLiveCollection();

    _userLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityUsers = event;
        });
      }
    });

    _userLiveCollection.observeLoadingState().listen((event) {
      if (mounted) {
        setState(() {
          loading = event;
        });
      }
    });

    _userLiveCollection.loadNext();
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
