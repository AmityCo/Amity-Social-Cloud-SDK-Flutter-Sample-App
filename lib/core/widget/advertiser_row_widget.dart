import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class AdvertiserRowWidget extends StatelessWidget {
  const AdvertiserRowWidget(
      {Key? key,
      required this.advertiserId,
      this.companyName,
      this.advertiserAvatar})
      : super(key: key);

  final String advertiserId;
  final AmityImage? advertiserAvatar;
  final String? companyName;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(
                .3,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: advertiserAvatar != null
                ? Image.network(
                    advertiserAvatar!.getUrl(AmityImageSize.MEDIUM),
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  companyName ?? 'company name is not available',
                  style: themeData.textTheme.titleLarge,
                ),
                Text(
                  'advertiserId: $advertiserId',
                  style: themeData.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
