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
                  Container(
                    margin: const EdgeInsets.all(4),
                    color: Colors.blueGrey.withOpacity(.25),
                    width: 130,
                    height: 130,
                    child: (amityAd.image1_1 != null)
                        ? Image.network(
                            amityAd.image1_1!.getUrl(AmityImageSize.MEDIUM),
                            fit: BoxFit.cover,
                          )
                        : const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "1:1 Ad image is not available",
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(4),
                      color: Colors.blueGrey.withOpacity(.25),
                      width: 130,
                      height: 130,
                      child: (amityAd.image9_16 != null)
                          ? Image.network(
                              amityAd.image9_16!.getUrl(AmityImageSize.MEDIUM),
                              fit: BoxFit.fitWidth,
                            )
                          : const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "9:16 Ad image is not available",
                                textAlign: TextAlign.center,
                              ),
                            ))
                ]),
          ],
        ),
      ),
    );
  }
}
