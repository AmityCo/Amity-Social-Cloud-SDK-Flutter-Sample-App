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
                GoRouter.of(context).pushNamed(AppRoute.channelProfile,
                    params: {'channelId': value.channelId!});
                // params: {'communityId': 'f5a99abc1f275df3f4259b6ca0e3cb15'});
              },
              child: Column(
                children: [
                  _ChannelInfoWidget(
                    amityChannel: value,
                  ),
                  const Divider(),
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
    return Container(
      padding: const EdgeInsets.all(8),
      key:const Key('channel_search_result_id'),
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
                  'Channel type - ' + amityChannel.amityChannelType.value,
                  style: _themeData.textTheme.subtitle1,
                ),
                Text(
                  'metadata: ${amityChannel.metadata ?? 'NaN'}',
                  style: _themeData.textTheme.caption,
                ),
                Text(
                  'tags: ${amityChannel.tags?.tags?.join(', ') ?? 'NaN'}',
                  style: _themeData.textTheme.caption,
                ),
                Text(
                  'last Activity: ${amityChannel.lastActivity?.toIso8601String() ?? 'NaN'}',
                  style: _themeData.textTheme.caption,
                ),
                SelectableText(
                  'Channel ID : ${amityChannel.channelId ?? 'NaN'}',
                  style: _themeData.textTheme.caption,
                ),
              ],
            ),
          ),
          Column(
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  label: Text('${amityChannel.memberCount}')),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.post_add_rounded),
                  label: Text('${amityChannel.messageCount}'))
            ],
          )
        ],
      ),
    );
  }
}
