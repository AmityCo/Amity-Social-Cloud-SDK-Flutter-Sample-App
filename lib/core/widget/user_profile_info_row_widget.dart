import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class UserProfileInfoRowWidget extends StatelessWidget {
  const UserProfileInfoRowWidget(
      {Key? key,
      required this.userId,
      required this.userAvatar,
      required this.userName,
      this.subTitle,
      this.options})
      : super(key: key);
  final String userId;
  final String? userAvatar;
  final String userName;
  final String? subTitle;
  final List<Widget>? options;

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
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
              color: Colors.grey.withOpacity(
                .3,
              ),
            ),
            child: userAvatar != null
                ? Image.network(
                    userAvatar!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 18),
          InkWell(
            onTap: () {
              GoRouter.of(context)
                  .goNamed(AppRoute.profile, params: {'userId': userId});
            },
            child: Column(
              children: [
                Text(
                  userName,
                  style: _themeData.textTheme.headline6,
                ),
                Text(
                  subTitle ?? '',
                  style: _themeData.textTheme.caption,
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
}
