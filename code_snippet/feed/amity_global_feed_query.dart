import 'package:amity_sdk/amity_sdk.dart';

class AmityGlobalFeedQuery {
  /* begin_sample_code
    gist_id: e588d9c4cfbaf490b115a87df2ec61fa
    filename: AmityGlobalFeedQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post example
    */
  final amityPosts = <AmityPost>[];
  late PagingController<AmityPost> _controller;

  void initPagingController() {
    //inititate the PagingController
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getGlobalFeed()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_controller.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            amityPosts.clear();
            amityPosts.addAll(_controller.loadedItems);
            //update widgets
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );
  }

//when the ListView widget is reached the bottom of the
//page, you need to trigger next page by calling
//_controller.fetchNextPage()
  void loadMore() {
    _controller.fetchNextPage()
        //optional
        .then((value) {
      //success
    });
  }
  /* end_sample_code */
}
