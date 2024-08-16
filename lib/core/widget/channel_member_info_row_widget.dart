import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class ChannelMemberInfoRowWidget extends StatelessWidget {
  const ChannelMemberInfoRowWidget(
      {Key? key, required this.channelMember, this.options})
      : super(key: key);
  final AmityChannelMember channelMember;
  final List<Widget>? options;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    // final isBanned = channelMember.
    return StreamBuilder<AmityChannelMember>(
      stream: channelMember.listen.stream,
      initialData: channelMember,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          final rolesText = (value.roles ?? ['']).toString();
          final permissionText =
              (value.permissions?.permissions ?? ['']).toString();
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
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: value.user?.avatarUrl != null
                      ? InkWell(
                          onTap: () {
                            GoRouter.of(context).pushNamed(AppRoute.profile,
                                params: {'userId': value.userId ?? ''});
                          },
                          child: Image.network(
                            value.user!.avatarUrl!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Image.asset('assets/user_placeholder.png'),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).pushNamed(AppRoute.profile,
                          params: {'userId': value.userId ?? ''});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.user?.displayName ?? 'unknown',
                          style: themeData.textTheme.titleMedium,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'roles - $rolesText',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'permissions - $permissionText',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'isBanned - ${value.isBanned ?? false}',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'isMuted - ${value.isMuted ?? false}',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'isDeleted - ${value.isDeleted ?? false}',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'Flag Count - ${value.user?.flagCount ?? 0}',
                          style: themeData.textTheme.bodySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ...?options
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
