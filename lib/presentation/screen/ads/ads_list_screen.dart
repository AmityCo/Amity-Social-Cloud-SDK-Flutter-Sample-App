import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/ad_widget.dart';

class AdsListScreen extends StatefulWidget {
  const AdsListScreen({Key? key}) : super(key: key);
  @override
  State<AdsListScreen> createState() => _AdsListScreenState();
}

final ScrollController scrollController = ScrollController();

class _AdsListScreenState extends State<AdsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads List 👩‍🚀'),
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
                  if (snapshot.hasData &&
                      (snapshot.data?.ads?.isNotEmpty ?? false)) {
                    List<AmityAd> networkAds = snapshot.data!.ads!;
                    return ListView.builder(
                        controller: ScrollController(),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: networkAds.length,
                        itemBuilder: (context, index) {
                          final networkAd = networkAds[index];
                          return AdWidget(key: UniqueKey(), amityAd: networkAd);
                        });
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
