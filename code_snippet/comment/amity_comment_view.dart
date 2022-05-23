import 'package:amity_sdk/amity_sdk.dart';


class AmityCommentView {
  /* begin_sample_code
    gist_id: 98bb5b19bba38bdc733ca4a8c0fb0d45
    filename: AmityCommentObserve.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter view text comment example
    */
  void viewComment(AmityComment comment) {
    AmityCommentData data = comment.data!;
    if (data is CommentTextData) {
      String? commentText = data.text;
    }
  }
  /* end_sample_code */
}
