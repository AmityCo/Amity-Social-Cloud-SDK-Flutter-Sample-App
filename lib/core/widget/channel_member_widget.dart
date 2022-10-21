import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/channel_member_info_row_widget.dart';

// typedef ArgumentCallback<T> = void Function(T);

class ChannelMemberWidget extends StatelessWidget {
  final AmityChannelMember amityChannelMember;
  final VoidCallback onMemberCallback;
  final List<Widget>? options;
  const ChannelMemberWidget(
      {Key? key,
      required this.amityChannelMember,
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
      child: ChannelMemberInfoRowWidget(
        channelMember: amityChannelMember,
        options: options,
      ),
    );
  }
}
