import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_profile/community_profile_screen.dart';
import 'package:go_router/go_router.dart';

class CommunityWidget extends StatelessWidget {
  const CommunityWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AmityCommunity>(
      stream: amityCommunity.listen.stream,
      initialData: amityCommunity,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          return Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.2)),
            child: InkWell(
              onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommunityProfileScreen(
                      communityId: value.communityId!,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  _CommunityInfoWidget(
                    amityCommunity: value,
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _CommunityOwnerWidget(
                      amityUser: value.user!,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _CommunityInfoWidget extends StatelessWidget {
  const _CommunityInfoWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final hasPermission =
        AmityCoreClient.hasPermission(AmityPermission.EDIT_COMMUNITY)
            .atCommunity(amityCommunity.communityId ?? '')
            .check();
    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8),
      //   color: Colors.grey.withOpacity(.05),
      // ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: amityCommunity.avatarImage?.getUrl(AmityImageSize.MEDIUM) !=
                    null
                ? Image.network(
                    amityCommunity.avatarImage!.getUrl(AmityImageSize.MEDIUM),
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amityCommunity.displayName ?? '',
                  style: themeData.textTheme.titleLarge,
                ),
                Text(
                  'descritpion: ${amityCommunity.description ?? ''}',
                  style: themeData.textTheme.bodySmall,
                ),
                Text(
                  'tags: ${amityCommunity.tags.toString()}',
                  style: themeData.textTheme.bodySmall,
                ),
                Text(
                  'Public: ${amityCommunity.isPublic}',
                  style: themeData.textTheme.bodySmall,
                ),
                Text(
                  'isDeleted: ${amityCommunity.isDeleted}',
                  style: themeData.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (hasPermission)
            PopupMenuButton(
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Edit"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Delete (Soft)"),
                  ),
                  PopupMenuItem(
                    value: 3,
                    enabled: false,
                    child: Text("Delete (Hard)"),
                  )
                ];
              },
              child: const Icon(
                Icons.more_vert,
                size: 18,
              ),
              onSelected: (index) {
                if (index == 1) {
                  GoRouter.of(context).pushNamed(AppRoute.updateCommunity,
                      queryParams: {
                        'communityId': amityCommunity.communityId!
                      });
                }
                if (index == 2) {
                  amityCommunity.delete();
                }
              },
            ),
          Column(
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  label: Text('${amityCommunity.membersCount}')),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.post_add_rounded),
                  label: Text('${amityCommunity.postsCount}'))
            ],
          )
        ],
      ),
    );
  }
}

class _CommunityContentWidget extends StatelessWidget {
  const _CommunityContentWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text('Post Count - ${amityCommunity.postsCount}'),
          Text('Member Count - ${amityCommunity.membersCount}'),
          Text('MetaData - ${amityCommunity.metadata}'),
        ],
      ),
    );
  }
}

class _CommunityOwnerWidget extends StatelessWidget {
  const _CommunityOwnerWidget({Key? key, required this.amityUser})
      : super(key: key);
  final AmityUser amityUser;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(color: Colors.grey.withOpacity(.1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: amityUser.avatarUrl != null
                ? Image.network(
                    amityUser.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoute.profile,
                    params: {'userId': amityUser.userId!});
              },
              child: Text(
                amityUser.displayName!,
                style: themeData.textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
