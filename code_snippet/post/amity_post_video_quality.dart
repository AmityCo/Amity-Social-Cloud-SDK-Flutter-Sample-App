import 'package:amity_sdk/amity_sdk.dart';

class AmityPostVideoQaulity {
  /* begin_sample_code
    gist_id: e1ba4f88bf33a3421c9863a354720c6a
    filename: AmityPostVideoQaulity.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post video quality example
    */
  void getVideo(AmityPost post) {
    final AmityPostData? amityPostData = post.data;
    if (amityPostData != null) {
      final videoData = amityPostData as VideoData;
      //for high quality video
      videoData.getVideo(AmityVideoQuality.HIGH).then((AmityVideo video) {
        //handle result
      });
      //for low quality video
      videoData.getVideo(AmityVideoQuality.LOW).then((AmityVideo video) {
        //handle result
      });
    }
  }
  /* end_sample_code */
}
