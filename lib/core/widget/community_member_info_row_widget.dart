import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:go_router/go_router.dart';

import 'dialog/positive_dialog.dart';

class CommunityMemberInfoRowWidget extends StatelessWidget {
  const CommunityMemberInfoRowWidget(
      {Key? key, required this.communityMember, this.options})
      : super(key: key);
  final AmityCommunityMember communityMember;
  final List<Widget>? options;

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    final rolesText = (communityMember.roles ?? ['']).toString();
    // final isBanned = communityMember.
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(.05),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            child: communityMember.user?.avatarUrl != null
                ? Image.network(
                    communityMember.user!.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 18),
          InkWell(
            onTap: () {
              GoRouter.of(context).goNamed(AppRoute.home,
                  params: {'userId': communityMember.userId ?? ''});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  communityMember.user?.displayName ?? 'unknown',
                  style: _themeData.textTheme.subtitle1,
                  textAlign: TextAlign.start,
                ),
                Text(
                  'roles - $rolesText',
                  style: _themeData.textTheme.caption,
                  textAlign: TextAlign.start,
                ),
                Text(
                  'isBanned - ${communityMember.isBanned ?? false}',
                  style: _themeData.textTheme.caption,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          if (communityMember.userId != AmityCoreClient.getUserId())
            PopupMenuButton(
              itemBuilder: (context) {
                final isMemberBanned = communityMember.isBanned ?? false;
                final canBanMember = AmityCoreClient.hasPermission(
                        AmityPermission.BAN_COMMUNITY_USER)
                    .atCommunity(communityMember.communityId!)
                    .check();
                final canRemoveMember = AmityCoreClient.hasPermission(
                        AmityPermission.REMOVE_COMMUNITY_USER)
                    .atCommunity(communityMember.communityId!)
                    .check();
                final canAddRole =
                    AmityCoreClient.hasPermission(AmityPermission.CREATE_ROLE)
                        .atCommunity(communityMember.communityId!)
                        .check();
                final canRemoveRole =
                    AmityCoreClient.hasPermission(AmityPermission.DELETE_ROLE)
                        .atCommunity(communityMember.communityId!)
                        .check();
                return [
                  PopupMenuItem(
                    child: const Text("Remove"),
                    value: 1,
                    enabled: canRemoveMember,
                  ),
                  PopupMenuItem(
                    child: const Text("Ban"),
                    value: 2,
                    enabled: canBanMember && !isMemberBanned,
                  ),
                  PopupMenuItem(
                    child: const Text("Unban"),
                    value: 3,
                    enabled: canBanMember && isMemberBanned,
                  ),
                  PopupMenuItem(
                    child: const Text("Add role"),
                    value: 4,
                    enabled: canAddRole && !isMemberBanned,
                  ),
                  PopupMenuItem(
                    child: const Text("Remove role"),
                    value: 5,
                    enabled: canRemoveRole && !isMemberBanned,
                  )
                ];
              },
              child: const Icon(
                Icons.more_vert,
                size: 18,
              ),
              onSelected: (index) {
                if (index == 1) {
                  _removeMember(context);
                }
                if (index == 2) {
                  _banMember(context);
                }
                if (index == 3) {
                  _unbanMember(context);
                }
                if (index == 4) {
                  _addRole(context, 'community-moderator');
                }
                if (index == 5) {
                  _removeRole(context, 'community-moderator');
                }
              },
            ),
          const Spacer(),
          ...?options
        ],
      ),
    );
  }

  void _removeMember(BuildContext context) {
    AmitySocialClient.newCommunityRepository()
        .membership(communityMember.communityId!)
        .removeMembers([communityMember.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Member removed successfully')
            });
  }

  void _banMember(BuildContext context) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityMember.communityId!)
        .banMember([communityMember.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Member banned successfully')
            });
  }

  void _unbanMember(BuildContext context) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityMember.communityId!)
        .unbanMember([communityMember.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Member unbanned successfully')
            });
  }

  void _addRole(BuildContext context, String role) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityMember.communityId!)
        .addRole(role, [communityMember.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Role added successfully')
            });
  }

  void _removeRole(BuildContext context, String role) {
    AmitySocialClient.newCommunityRepository()
        .moderation(communityMember.communityId!)
        .removeRole(role, [communityMember.userId!])
        .onError((error, stackTrace) => {
              ErrorDialog.show(context,
                  title: 'Error', message: error.toString())
            })
        .then((value) => {
              PositiveDialog.show(context,
                  title: 'Complete', message: 'Role removed successfully')
            });
  }
}
