import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

// typedef ArgumentCallback<T> = void Function(T);

class CommunityMemberWidget extends StatelessWidget {
  final AmityCommunityMember amityCommunityMember;
  final VoidCallback onMemberCallback;
  final List<Widget>? options;
  const CommunityMemberWidget(
      {Key? key, required this.amityCommunityMember, required this.onMemberCallback, this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [
        BoxShadow(
          color: Colors.white,
          blurRadius: 10,
        ),
      ]),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      child: _CommunityMemberInfoRowWidget(communityMember: amityCommunityMember, options: options),
    );
  }
}

class _CommunityMemberInfoRowWidget extends StatelessWidget {
  const _CommunityMemberInfoRowWidget({Key? key, required this.communityMember, this.options}) : super(key: key);
  final AmityCommunityMember communityMember;
  final List<Widget>? options;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    // final isBanned = communityMember.
    return StreamBuilder<AmityCommunityMember>(
      stream: communityMember.listen.stream,
      initialData: communityMember,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: value.user?.avatarUrl != null
                      ? Image.network(
                          value.user!.avatarUrl!,
                          fit: BoxFit.fill,
                        )
                      : Image.asset('assets/user_placeholder.png'),
                ),
                const SizedBox(width: 18),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).pushNamed(AppRoute.profile, params: {'userId': value.userId ?? ''});
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
                        'isBanned - ${value.isBanned ?? false}',
                        style: themeData.textTheme.bodySmall,
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
