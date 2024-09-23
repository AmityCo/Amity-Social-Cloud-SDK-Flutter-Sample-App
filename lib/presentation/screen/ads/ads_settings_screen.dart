import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class AdsSettingsScreen extends StatefulWidget {
  const AdsSettingsScreen({Key? key}) : super(key: key);
  @override
  State<AdsSettingsScreen> createState() => _AdsSettingsScreenState();
}

final ScrollController scrollController = ScrollController();

class _AdsSettingsScreenState extends State<AdsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads Settings ⚙️'),
      ),
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<AmityNetworkAds>(
                future: AmityCoreClient.newAdRepository().getNetworkAds(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && (snapshot.data?.settings != null)) {
                    AmityAdsSettings settings = snapshot.data!.settings!;
                    return Expanded(
                        child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Is enabled - ${settings.isEnabled ?? 'N/A'}',
                            style: themeData.textTheme.bodyMedium,
                          ),
                          Text(
                            'Max active - ${settings.maxActiveAds ?? 'N/A'}',
                            style: themeData.textTheme.bodyMedium,
                          ),
                          Text(
                            'Feed frequency- ${settings.getFrequency()?.getFeedAdFrequency().type ?? 'N/A'} ${settings.getFrequency()?.getFeedAdFrequency().value ?? 'N/A'}',
                            style: themeData.textTheme.bodyMedium,
                          ),
                          Text(
                            'Story frequency- ${settings.getFrequency()?.getStoryAdFrequency().type ?? 'N/A'} ${settings.getFrequency()?.getStoryAdFrequency().value ?? 'N/A'}',
                            style: themeData.textTheme.bodyMedium,
                          ),
                          Text(
                            'Comment frequency- ${settings.getFrequency()?.getCommentAdFrequency().type ?? 'N/A'} ${settings.getFrequency()?.getCommentAdFrequency().value ?? 'N/A'}',
                            style: themeData.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
