import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class SubChannelItemWidget extends StatelessWidget {
  final AmitySubChannel subChannel;
  const SubChannelItemWidget({super.key, required this.subChannel});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRoute.chat, params: {
            'channelId': subChannel.subChannelId!,
            'channelName': subChannel.displayName!,
          });
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subChannel.displayName ?? '<< No display name >>',
                  style: themeData.textTheme.titleLarge,
                ),
                Text(
                  'Message Count: ${subChannel.messageCount ?? 'NaN'}',
                  style: themeData.textTheme.bodySmall,
                ),
                // Text(
                //   'metadata: ${amityChannel.metadata ?? 'NaN'}',
                //   style: themeData.textTheme.bodySmall,
                // ),
                // Text(
                //   'tags: ${amityChannel.tags?.tags?.join(', ') ?? 'NaN'}',
                //   style: themeData.textTheme.bodySmall,
                // ),
                Text(
                  'last Activity: ${subChannel.lastActivity?.toIso8601String() ?? 'NaN'}',
                  style: themeData.textTheme.bodySmall,
                ),
                Text(
                  'isDeleted: ${subChannel.isDeleted ?? 'NaN'}',
                  style: themeData.textTheme.bodySmall,
                ),
                SelectableText(
                  'SubChannel ID : ${subChannel.subChannelId ?? 'NaN'}',
                  style: themeData.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
