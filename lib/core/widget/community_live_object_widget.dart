import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/community_widget.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_post/update_post_screen.dart';
import 'package:go_router/go_router.dart';

class CommunityLiveObjectWidget extends StatelessWidget {
  final String? communityId;

  const CommunityLiveObjectWidget(
      {Key? key,
      this.communityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return StreamBuilder<AmityCommunity>(
      stream: AmitySocialClient.newCommunityRepository()
          .live
          .getCommunity(communityId!),
      builder: (context, snapshot) {
        final value = snapshot.data;
        if (value != null) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(12),
                  child: CommunityWidget(
                    amityCommunity: value,
                  ),
                );
              },
            ),

          );
        } else {
          return Container();
        }
      },
    );

  }
}
