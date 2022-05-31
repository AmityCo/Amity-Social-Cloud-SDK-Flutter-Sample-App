import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_info_row_widget.dart';

// typedef ArgumentCallback<T> = void Function(T);

class CommunityMemberWidget extends StatelessWidget {
  final AmityCommunityMember amityCommunityMember;
  final VoidCallback onMemberCallback;
  final List<Widget>? options;
  const CommunityMemberWidget(
      {Key? key,
      required this.amityCommunityMember,
      required this.onMemberCallback,
      this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child:
          CommunityMemberInfoRowWidget(communityMember: amityCommunityMember, options: options),
    );
  }
}
