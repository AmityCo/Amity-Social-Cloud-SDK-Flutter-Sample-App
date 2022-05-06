import 'package:amity_sdk/amity_sdk.dart';

class AmityPostImageGet {
  /* begin_sample_code
    gist_id: 7c3d2970b1767a66f623cfc129046f2f
    filename: AmityPostImageGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get image from post example
    */
  void getImage(AmityPost post) {
    final AmityPostData? amityPostData = post.data;
    if (amityPostData != null) {
      final imageData = amityPostData as ImageData;
      //for large image url
      final largeImageUrl = imageData.getUrl(AmityImageSize.LARGE);
      //for small image url
      final smallImageUrl = imageData.getUrl(AmityImageSize.SMALL);
    }
  }
  /* end_sample_code */
}
