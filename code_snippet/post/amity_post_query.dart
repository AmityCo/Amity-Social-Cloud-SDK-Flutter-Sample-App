import 'package:amity_sdk/amity_sdk.dart';

class AmityPostQuery {
  /* begin_sample_code
    gist_id: 620ff77fd5a1ce4fa71fba3d96634ef2
    filename: AmityPostQuery.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter query post example
    */
  final amityPosts = <AmityPost>[];
  late PagingController<AmityPost> _controller;

  //User's Media Gallery Example
  //For this use-case:
  //  - Search all the "image" and "video" posts - Belong to the user "steven".
  //  - Only non-deleted posts.
  //  - Sorted by last created.
  void initPagingController(String communityId) {
    //inititate the PagingController
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newPostRepository()
          .getPosts()
          .targetUser('steven')
          //supported data types are IMAGE, VIDEO, and FILE
          .types([AmityDataType.IMAGE, AmityDataType.VIDEO])
          //feedType could be AmityFeedType.PUBLISHED, AmityFeedType.REVIEWING, AmityFeedType.DECLINED
          .feedType(AmityFeedType.PUBLISHED)
          .includeDeleted(false)
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
