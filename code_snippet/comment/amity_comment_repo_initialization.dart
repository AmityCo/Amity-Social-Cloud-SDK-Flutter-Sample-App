import 'package:amity_sdk/amity_sdk.dart';


class AmityCommentRepoInitialization {
  /* begin_sample_code
    gist_id: 0175953fbd804e31dde252f26c3d8819
    filename: AmityCommentRepoInitialization.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create comment repo example
    */
  void initCommentRepo() {
    CommentRepository commentRepository = AmitySocialClient.newCommentRepository();
  }
  /* end_sample_code */
}
