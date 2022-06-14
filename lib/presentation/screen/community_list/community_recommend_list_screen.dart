import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

import 'package:flutter_social_sample_app/core/widget/community_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class CommunityRecommendListScreen extends StatefulWidget {
  const CommunityRecommendListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityRecommendListScreen> createState() =>
      _CommunityRecommendListScreenState();
}

class _CommunityRecommendListScreenState
    extends State<CommunityRecommendListScreen> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Recommended List')),
      body: Column(
        children: [communityListWidget()],
      ),
    );
  }

  Widget communityListWidget() {
    return FutureBuilder<List<AmityCommunity>>(
        future: AmitySocialClient.newCommunityRepository()
            .getRecommendedCommunities()
            .whenComplete(() => {isLoading = false}),
        builder: (context, snapshot) {
          return Expanded(
            child: (snapshot.data != null && snapshot.data!.isNotEmpty)
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final amityCommunity = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(12),
                        child: CommunityWidget(
                          amityCommunity: amityCommunity,
                        ),
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('No Communities'),
                  ),
          );
        });
  }
}
