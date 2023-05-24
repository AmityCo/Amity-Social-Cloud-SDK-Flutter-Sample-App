import 'package:amity_sdk/amity_sdk.dart';

class AmityPostVideoThumbnail {
  /* begin_sample_code
    gist_id: 523023fe3fd2d1384f7b22f75ca62d4b
    filename: AmityPostVideoThumbnail.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post video quality example
    */
  void getVideo(AmityPost post) {
    final AmityPostData? amityPostData = post.data;
    if (amityPostData != null) {
      final videoData = amityPostData as VideoData;
      //retreiving an amity image from a video
      final AmityImage? thumbnail = videoData.thumbnail;
      //retreiving a large image url from an amity image
      //the possible sizes are SMALL, MEDIUM, LARGE, FULL
      final String? largeImageUrl = thumbnail?.getUrl(AmityImageSize.LARGE);
    }
  }
  /* end_sample_code */
}
