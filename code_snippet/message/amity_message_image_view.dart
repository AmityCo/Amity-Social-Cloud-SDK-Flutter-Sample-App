import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageImageView {
  /* begin_sample_code
    gist_id: a160651275e49be13b7d2f9f1ab02a68
    filename: AmityMessageImageView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message image view example
    */
  void viewImageMessage(AmityMessage message) {
    if (message.data is MessageImageData) {
      final imageUrl =
          (message.data as MessageImageData).image.getUrl(AmityImageSize.FULL);

      final smallImageUrl =
          (message.data as MessageImageData).image.getUrl(AmityImageSize.SMALL);

      final mediumImageUrl = (message.data as MessageImageData)
          .image
          .getUrl(AmityImageSize.MEDIUM);

      final largeImageUrl =
          (message.data as MessageImageData).image.getUrl(AmityImageSize.LARGE);
    }
  }
  /* end_sample_code */
}
