import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';


class CommunityMemberInfoRowWidget extends StatelessWidget {
  const CommunityMemberInfoRowWidget(
      {Key? key, required this.communityMember, this.options})
      : super(key: key);
  final AmityCommunityMember communityMember;
  final List<Widget>? options;

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    // final isBanned = communityMember.
    return StreamBuilder<AmityCommunityMember>(
      stream: communityMember.listen,
      initialData: communityMember,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!);
          final value = snapshot.data!;
          final rolesText = (value.roles ?? ['']).toString();
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
                  child: value.user?.avatarUrl != null
                      ? Image.network(
                          value.user!.avatarUrl!,
                          fit: BoxFit.fill,
                        )
                      : Image.asset('assets/user_placeholder.png'),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                ),
                const SizedBox(width: 18),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).goNamed(AppRoute.home,
                        params: {'userId': value.userId ?? ''});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.user?.displayName ?? 'unknown',
                        style: _themeData.textTheme.subtitle1,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'roles - $rolesText',
                        style: _themeData.textTheme.caption,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'isBanned - ${value.isBanned ?? false}',
                        style: _themeData.textTheme.caption,
                        textAlign: TextAlign.start,
                      ),
                    ],
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
