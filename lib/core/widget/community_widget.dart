import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class CommunityWidget extends StatelessWidget {
  const CommunityWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;

  @override
  Widget build(BuildContext context) {
    if (amityCommunity.isDeleted ?? false) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(.05)),
        child: Text('Community Deleted - ${amityCommunity.communityId}'),
      );
    }
    return StreamBuilder<AmityCommunity>(
      stream: amityCommunity.listen,
      initialData: amityCommunity,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          return Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.2)),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).goNamed(AppRoute.communityProfile,
                    params: {'communityId': value.communityId!});
                // params: {'communityId': 'f5a99abc1f275df3f4259b6ca0e3cb15'});
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
    final _themeData = Theme.of(context);
    final _hasPermission = AmityCoreClient.hasPermission(AmityPermission.EDIT_COMMUNITY)
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
            child: amityCommunity.avatarImage?.getUrl(AmityImageSize.MEDIUM) !=
                    null
                ? Image.network(
                    amityCommunity.avatarImage!.getUrl(AmityImageSize.MEDIUM),
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amityCommunity.displayName ?? '',
                  style: _themeData.textTheme.headline6,
                ),
                Text(
                  amityCommunity.description ?? '',
                  style: _themeData.textTheme.caption,
                ),
              ],
            ),
          ),
          if (_hasPermission)
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
                  )
                ];
              },
              child: const Icon(
                Icons.more_vert,
                size: 18,
              ),
              onSelected: (index) {
                if (index == 1) {
                  GoRouter.of(context).goNamed(AppRoute.updateCommunity,
                      params: {'communityId': amityCommunity.communityId!});
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
                  icon: Icon(Icons.person),
                  label: Text('${amityCommunity.membersCount}')),
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.post_add_rounded),
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
    final _themeData = Theme.of(context);
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
            child: amityUser.avatarUrl != null
                ? Image.network(
                    amityUser.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 18),
          InkWell(
            onTap: () {
              GoRouter.of(context).goNamed(AppRoute.home,
                  params: {'userId': amityUser.userId!});
            },
            child: Column(
              children: [
                Text(
                  amityUser.displayName!,
                  style: _themeData.textTheme.bodyText1,
                ),
                // Text(
                //   subTitle ?? '',
                //   style: _themeData.textTheme.caption,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
