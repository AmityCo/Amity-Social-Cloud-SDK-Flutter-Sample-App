import 'package:amity_sdk/amity_sdk.dart';

class AmityImageGetUrl {
  /* begin_sample_code
    gist_id: 1dc61cf1110bf36aca0e3dab6b388e9a
    filename: AmityGetImageUrl.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get image url example
    */
  void getImageUrl(AmityImage amityImage) {
      //retreiving a large image url from an amity image
      //the possible sizes are SMALL, MEDIUM, LARGE, FULL
      final String largeImageUrl = amityImage.getUrl(AmityImageSize.LARGE);
      final String smallImageUrl = amityImage.getUrl(AmityImageSize.SMALL);
  }
  /* end_sample_code */
}
