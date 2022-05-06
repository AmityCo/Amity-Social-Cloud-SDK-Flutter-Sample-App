import 'package:amity_sdk/lib.dart';
import 'package:amity_sdk/public/client/amity_social_client.dart';

class AmityCommentQuery {
  /* begin_sample_code
    gist_id: 5c680bbc0f6a10357ed589fcd6cd3534
    filename: AmityCommentQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query comments example
    */
  final amityComments = <AmityComment>[];
  late PagingController<AmityComment> _controller;

  void queryComments(String postId) {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(postId)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_controller.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityComments.clear();
            amityComments.addAll(_controller.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );
  }
  /* end_sample_code */
}
