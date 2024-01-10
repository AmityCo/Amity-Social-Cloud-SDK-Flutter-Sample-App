import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class UserPostScreen extends StatefulWidget {
  const UserPostScreen({Key? key, required this.userId, this.showAppBar = true}) : super(key: key);
  final bool showAppBar;
  final String userId;
  @override
  State<UserPostScreen> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {
  List<AmityPost> amityPosts = <AmityPost>[];

  late PostLiveCollection postLiveCollection;
  final scrollcontroller = ScrollController();

  bool loading = false;


  @override
  void initState() {

    postLiveCollection = PostLiveCollection(
      request: () => AmitySocialClient.newPostRepository()
          .getPosts()
          .targetUser(widget.userId).build(),
    );

    postLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityPosts = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

    // _controller = PagingController(
    //   pageFuture: (token) => AmitySocialClient.newPostRepository()
    //       .getPosts()
    //       .targetUser(widget.userId)
    //       .getPagingData(token: token, limit: GlobalConstant.pageSize),
    //   pageSize: GlobalConstant.pageSize,
    // )..addListener(
    //     () {
    //       setState(() {
    //         amityPosts.clear();
    //         amityPosts.addAll(_controller.loadedItems);
    //       });
    //     },
    //   );

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _controller.fetchNextPage();
    // });

    // scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            (scrollcontroller.position.maxScrollExtent)) &&
        postLiveCollection.hasNextPage()) {
      postLiveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text('User Post - ${widget.userId}')) : null,
      body: amityPosts.isEmpty
          ? const Center(
              child: Text('No Post Found' ),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      postLiveCollection.reset();
                      postLiveCollection.getFirstPageRequest();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityPosts.length,
                      itemBuilder: (context, index) {
                        final amityPost = amityPosts[index];
                        return FeedWidget(
                          key: UniqueKey(),
                          amityPost: amityPost,
                        );
                      },
                    ),
                  ),
                ),
                if (postLiveCollection.isFetching)
                  Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
              ],
            ),
    );
  }
}
