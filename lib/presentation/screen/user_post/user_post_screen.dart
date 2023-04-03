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
  late PagingController<AmityPost> _controller;
  final amityPosts = <AmityPost>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newPostRepository()
          .getPosts()
          .targetUser(widget.userId)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          setState(() {
            amityPosts.clear();
            amityPosts.addAll(_controller.loadedItems);
          });
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels == scrollcontroller.position.maxScrollExtent) && _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text('User Post - ${widget.userId}')) : null,
      body: amityPosts.isEmpty
          ? Center(
              child: Text(_controller.error == null ? 'No Post Found' : _controller.error.toString()),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityPosts.length,
                      itemBuilder: (context, index) {
                        final amityPost = amityPosts[index];
                        return FeedWidget(
                          amityPost: amityPost,
                        );
                      },
                    ),
                  ),
                ),
                if (_controller.isFetching)
                  Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
              ],
            ),
    );
  }
}
