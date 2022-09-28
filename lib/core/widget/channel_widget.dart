import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class ChannelWidget extends StatelessWidget {
  const ChannelWidget({Key? key, required this.amityChannel}) : super(key: key);
  final AmityChannel amityChannel;

  @override
  Widget build(BuildContext context) {
    if (amityChannel.isDeleted ?? false) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(.05)),
        child: Text('Channel Deleted - ${amityChannel.channelId}'),
      );
    }
    return StreamBuilder<AmityChannel>(
      stream: amityChannel.listen.stream,
      initialData: amityChannel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          return Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.2)),
            child: InkWell(
              onTap: () {
                GoRouter.of(context).goNamed(AppRoute.channelProfile,
                    params: {'channelId': value.channelId!});
                // params: {'communityId': 'f5a99abc1f275df3f4259b6ca0e3cb15'});
              },
              child: Column(
                children: [
                  _ChannelInfoWidget(
                    amityChannel: value,
                  ),
                  const Divider(),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: _ChannelOwnerWidget(
                  //     amityUser: value.avatar!,
                  //   ),
                  // )
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

class _ChannelInfoWidget extends StatelessWidget {
  const _ChannelInfoWidget({Key? key, required this.amityChannel})
      : super(key: key);
  final AmityChannel amityChannel;

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    // final _hasPermission =
    //     AmityCoreClient.hasPermission(AmityPermission.EDIT_COMMUNITY)
    //         .atChannel(amityChannel.communityId ?? '')
    //         .check();
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
            child: amityChannel.avatar?.getUrl(AmityImageSize.MEDIUM) != null
                ? Image.network(
                    amityChannel.avatar!.getUrl(AmityImageSize.MEDIUM),
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
                  amityChannel.displayName ?? '<< No display name >>',
                  style: _themeData.textTheme.headline6,
                ),
                Text(
                  'metadata: ${amityChannel.metadata ?? ''}',
                  style: _themeData.textTheme.caption,
                ),
                Text(
                  'tags: ${amityChannel.tags.toString()}',
                  style: _themeData.textTheme.caption,
                ),
              ],
            ),
          ),
          // if (_hasPermission)
          //   PopupMenuButton(
          //     itemBuilder: (context) {
          //       return const [
          //         PopupMenuItem(
          //           child: Text("Edit"),
          //           value: 1,
          //         ),
          //         PopupMenuItem(
          //           child: Text("Delete (Soft)"),
          //           value: 2,
          //         ),
          //         PopupMenuItem(
          //           child: Text("Delete (Hard)"),
          //           value: 3,
          //           enabled: false,
          //         )
          //       ];
          //     },
          //     child: const Icon(
          //       Icons.more_vert,
          //       size: 18,
          //     ),
          //     onSelected: (index) {
          //       if (index == 1) {
          //         GoRouter.of(context).goNamed(AppRoute.updateChannel,
          //             params: {'communityId': amityChannel.communityId!});
          //       }
          //       if (index == 2) {
          //         amityChannel.delete();
          //       }
          //     },
          //   ),
          Column(
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person),
                  label: Text('${amityChannel.memberCount}')),
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.post_add_rounded),
                  label: Text('${amityChannel.messageCount}'))
            ],
          )
        ],
      ),
    );
  }
}

class _ChannelContentWidget extends StatelessWidget {
  const _ChannelContentWidget({Key? key, required this.amityChannel})
      : super(key: key);
  final AmityChannel amityChannel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text('Message Count - ${amityChannel.messageCount}'),
          Text('Member Count - ${amityChannel.memberCount}'),
          Text('MetaData - ${amityChannel.metadata}'),
        ],
      ),
    );
  }
}

class _ChannelOwnerWidget extends StatelessWidget {
  const _ChannelOwnerWidget({Key? key, required this.amityUser})
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
