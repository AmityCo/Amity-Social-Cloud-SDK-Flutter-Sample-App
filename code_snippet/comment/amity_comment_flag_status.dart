import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentFlagStatus {
  /* begin_sample_code
    gist_id: f192a0901b323ba0fec688f865e429c7
    filename: AmityCommentFlagStatus.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter flag comment status example
    */
  void getFlagStatus(AmityComment comment) {
    final isFlaggedByMe = comment.isFlaggedByMe;
  }
  /* end_sample_code */
}
