import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/community_widget.dart';

class CommunityTrendingListScreen extends StatefulWidget {
  const CommunityTrendingListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityTrendingListScreen> createState() =>
      _CommunityTrendingListScreenState();
}

class _CommunityTrendingListScreenState
    extends State<CommunityTrendingListScreen> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Trending List')),
      body: Column(
        children: [communityListWidget()],
      ),
    );
  }

  Widget communityListWidget() {
    return FutureBuilder<List<AmityCommunity>>(
        future: AmitySocialClient.newCommunityRepository()
            .getTrendingCommunities()
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
