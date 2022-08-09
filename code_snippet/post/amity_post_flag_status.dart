import 'package:amity_sdk/amity_sdk.dart';

class AmityPostFlagStatus {
  /* begin_sample_code
    gist_id: 524aceb00b5ff5bd6373628274f30c1d
    filename: AmityPostFlagStatus.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag post status example
    */
  void getFlagStatus(AmityPost post) {
    final isFlaggedByMe = post.isFlaggedByMe;
  }
  /* end_sample_code */
}
