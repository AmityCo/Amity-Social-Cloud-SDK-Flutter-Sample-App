import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';

class CommunityMemberScreen extends StatefulWidget {
  CommunityMemberScreen(
      {Key? key, required this.communityId, this.showAppBar = true})
      : super(key: key);
  final String communityId;
  final bool showAppBar;
  // late _CommunityMemberScreenState screenState;
  @override
  State<CommunityMemberScreen> createState() => CommunityMemberScreenState();
}

class CommunityMemberScreenState extends State<CommunityMemberScreen> {
  late PagingController<AmityCommunityMember> _controller;
  final amityCommunityMembers = <AmityCommunityMember>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  String _keyboard = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityCommunityMembershipFilter _filter =
      AmityCommunityMembershipFilter.MEMBER;
  AmityCommunityMembershipSortOption _sort =
      AmityCommunityMembershipSortOption.LAST_CREATED;
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(widget.communityId)
          .searchMembers(_keyboard)
          .filter(_filter)
          .sortBy(_sort)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            if (mounted) {
              setState(() {
                amityCommunityMembers.clear();
                amityCommunityMembers.addAll(_controller.loadedItems);
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

  void addMembers(List<AmityCommunityMember> members) {
    _controller.addAll(members);
  }

  void removeMembers(List<String> userIds) {
    _controller.removeWhere((member) {
      print(
          ' ${member.userId} does it contain ${userIds.contains(member.userId)}');
      return userIds.contains(member.userId);
    });
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
          ? AppBar(title: Text('Community Members - ${widget.communityId}'))
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: TextFormField(
              onChanged: (value) {
                _debouncer.run(() {
                  _keyboard = value;
                  _controller.reset();
                  _controller.fetchNextPage();
                });
              },
              decoration: const InputDecoration(hintText: 'Enter Keybaord'),
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child: Text(AmityCommunityMembershipFilter.ALL.name),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child:
                              Text(AmityCommunityMembershipFilter.MEMBER.name),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child:
                              Text(AmityCommunityMembershipFilter.BANNED.name),
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _filter = AmityCommunityMembershipFilter.ALL;
                      }
                      if (index == 2) {
                        _filter = AmityCommunityMembershipFilter.MEMBER;
                      }
                      if (index == 3) {
                        _filter = AmityCommunityMembershipFilter.BANNED;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child: Text(AmityCommunityMembershipSortOption
                              .FIRST_CREATED.name),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(AmityCommunityMembershipSortOption
                              .LAST_CREATED.name),
                        ),
                      ];
                    },
                    child: const Icon(
                      Icons.sort_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _sort =
                            AmityCommunityMembershipSortOption.FIRST_CREATED;
                      }
                      if (index == 2) {
                        _sort = AmityCommunityMembershipSortOption.LAST_CREATED;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: amityCommunityMembers.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollcontroller,
                      itemCount: amityCommunityMembers.length,
                      itemBuilder: (context, index) {
                        final amityCommunityMember =
                            amityCommunityMembers[index];
                        return CommunityMemberWidget(
                          key: UniqueKey(),
                          amityCommunityMember: amityCommunityMember,
                          onMemberCallback: () {},
                          options: [
                            PopupMenuButton(
                              itemBuilder: (context) {
                                final isMemberBanned =
                                    amityCommunityMember.isBanned ?? false;
                                final canBanMember =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.BAN_COMMUNITY_USER)
                                        .atCommunity(
                                            amityCommunityMember.communityId!)
                                        .check();
                                final canRemoveMember =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission
                                                .REMOVE_COMMUNITY_USER)
                                        .atCommunity(
                                            amityCommunityMember.communityId!)
                                        .check();
                                final canAddRole =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.CREATE_ROLE)
                                        .atCommunity(
                                            amityCommunityMember.communityId!)
                                        .check();
                                final canRemoveRole =
                                    AmityCoreClient.hasPermission(
                                            AmityPermission.DELETE_ROLE)
                                        .atCommunity(
                                            amityCommunityMember.communityId!)
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
                                  )
                                ];
                              },
                              child: const Icon(
                                Icons.more_vert,
                                size: 18,
                              ),
                              onSelected: (index) {
                                if (index == 1) {
                                  _removeMember(context, amityCommunityMember);
                                }
                                if (index == 2) {
                                  _banMember(context, amityCommunityMember);
                                }
                                if (index == 3) {
                                  _unbanMember(context, amityCommunityMember);
                                }
                                if (index == 4) {
                                  _addRole(context, amityCommunityMember);
                                }
                                if (index == 5) {
                                  _removeRole(context, amityCommunityMember);
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
          if (_controller.isFetching && amityCommunityMembers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  void _removeMember(BuildContext context, AmityCommunityMember member) {
    AmitySocialClient.newCommunityRepository()
        .membership(member.communityId!)
        .removeMembers([member.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              removeMembers([member.userId!])
            });
  }

  void _banMember(BuildContext context, AmityCommunityMember value) {
    AmitySocialClient.newCommunityRepository()
        .moderation(value.communityId!)
        .banMember([value.userId!])
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

  void _unbanMember(BuildContext context, AmityCommunityMember value) {
    AmitySocialClient.newCommunityRepository()
        .moderation(value.communityId!)
        .unbanMember([value.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Member unbanned successfully')
            });
  }

  void _addRole(BuildContext context, AmityCommunityMember member) {
    AmitySocialClient.newCommunityRepository()
        .moderation(member.communityId!)
        .addRole('community-moderator', [member.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              AmitySocialClient.newCommunityRepository()
                  .moderation(member.communityId!)
                  .addRole('channel-moderator', [member.userId!]).then(
                      (value) => {
                            PositiveDialog.show(context,
                                title: 'Complete',
                                message: 'Role added successfully')
                          })
            });
  }

  void _removeRole(BuildContext context, AmityCommunityMember member) {
    AmitySocialClient.newCommunityRepository()
        .moderation(member.communityId!)
        .removeRole('community-moderator', [member.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              AmitySocialClient.newCommunityRepository()
                  .moderation(member.communityId!)
                  .removeRole('channel-moderator', [member.userId!]).then(
                      (value) => {
                            PositiveDialog.show(context,
                                title: 'Complete',
                                message: 'Role removed successfully')
                          })
            });
  }
}
