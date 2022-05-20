import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';

typedef ArgumentCallback<T> = void Function(T);

class CommunityMemberWidget extends StatelessWidget {
  final AmityCommunityMember amityCommunityMember;
  final VoidCallback onMemberCallback;
  const CommunityMemberWidget(
      {Key? key,
      required this.amityCommunityMember,
      required this.onMemberCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AmityCommunityMember>(
      valueListenable: amityCommunityMember,
      builder: (context, value, child) {
        return Stack(
          fit: StackFit.loose,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                    ),
                  ]),
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileInfoRowWidget(
                    userId: value.user!.userId!,
                    userAvatar: value.user!.avatarCustomUrl,
                    userName: value.user!.displayName!,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
