import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/advertiser_row_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AdWidget extends StatelessWidget {
  final AmityAd amityAd;

  const AdWidget({Key? key, required this.amityAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AdvertiserRowWidget(
                advertiserId: amityAd.advertiserId ?? '',
                companyName: amityAd.advertiser?.companyName,
                advertiserAvatar: amityAd.advertiser?.avatar),
            Text(
              'Ad id - ${amityAd.adId}',
              style: themeData.textTheme.bodySmall,
            ),
            Text(
              'Target - ${amityAd.adTarget}',
              style: themeData.textTheme.bodySmall,
            ),
            Text(
              'Placements - ${amityAd.placements}',
              style: themeData.textTheme.bodySmall,
            ),
            Text(
              'Start at - ${amityAd.startAt ?? 'N/A'}',
              style: themeData.textTheme.bodySmall,
            ),
            Text(
              'End at - ${amityAd.endAt ?? 'forever'}',
              style: themeData.textTheme.bodySmall,
            ),
            Text(
              'Name - ${amityAd.name}',
              style: themeData.textTheme.titleMedium,
            ),
            Text(
              'Headline - ${amityAd.headline ?? 'N/A - Headline is not available'}',
              style: themeData.textTheme.titleLarge,
            ),
            Text(
              'Description - ${amityAd.description ?? 'N/A - Description is not available'}',
              style: themeData.textTheme.bodyMedium,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                ]),
            // InkWell(
            //   onTap: () async {
            //     if (amityAd.image1_1 != null) {
            //       await launchUrl(Uri.parse(
            //           amityAd.image1_1!.getUrl(AmityImageSize.FULL)));
            //     }
            //   },
            //   child: Text(
            //       'Image 1:1 - ${amityAd.image1_1?.getUrl(AmityImageSize.FULL) ?? 'N/A'}',
            //       style: const TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w400,
            //           color: Colors.blueAccent)),
            // ),
            // InkWell(
            //   onTap: () async {
            //     if (amityAd.image9_16 != null) {
            //       await launchUrl(Uri.parse(
            //           amityAd.image9_16!.getUrl(AmityImageSize.FULL)));
            //     }
            //   },
            //   child: Text(
            //       'Image 9:16 - ${amityAd.image9_16?.getUrl(AmityImageSize.FULL) ?? 'N/A'}',
            //       style: const TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w400,
            //           color: Colors.blueAccent)),
            // ),
            // InkWell(
            //   onTap: () async {
            //     if (amityAd.callToActionUrl != null) {
            //       await launchUrl(Uri.parse(amityAd.callToActionUrl!));
            //     }
            //   },
            //   child: Text(
            //       'Call to Action - ${amityAd.image9_16?.getUrl(AmityImageSize.FULL) ?? 'N/A'}',
            //       style: themeData.textTheme.titleMedium),
            // ),
          ],
        ),
      ),
    );
  }
}
