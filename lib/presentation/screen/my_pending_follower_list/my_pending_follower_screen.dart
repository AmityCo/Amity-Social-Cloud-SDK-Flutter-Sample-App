import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class MyPendingFollowerScreen extends StatefulWidget {
  const MyPendingFollowerScreen({Key? key}) : super(key: key);
  @override
  State<MyPendingFollowerScreen> createState() =>
      _MyPendingFollowerScreenState();
}

class _MyPendingFollowerScreenState extends State<MyPendingFollowerScreen> {
  late PagingController<AmityFollowRelationship> _controller;
  final amityFollowRelationships = <AmityFollowRelationship>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  // AmityComment? _replyToComment;

  // AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .me()
          .getFollowers()
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityFollowRelationships.clear();
              amityFollowRelationships.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context,
                title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follower List'),
        actions: const [
          // PopupMenuButton(
          //   itemBuilder: (context) {
          //     return [
          //       PopupMenuItem(
          //         child: Text(AmityCommentSortOption.LAST_CREATED.apiKey),
          //         value: 1,
          //       ),
          //       PopupMenuItem(
          //         child: Text(AmityCommentSortOption.FIRST_CREATED.apiKey),
          //         value: 2,
          //       ),
          //     ];
          //   },
          //   child: const Icon(
          //     Icons.sort_rounded,
          //     size: 24,
          //   ),
          //   onSelected: (index1) {
          //     if (index1 == 1) {
          //       _sortOption = AmityCommentSortOption.LAST_CREATED;
          //       _controller.reset();
          //       _controller.fetchNextPage();
          //     }
          //     if (index1 == 2) {
          //       _sortOption = AmityCommentSortOption.FIRST_CREATED;
          //       _controller.reset();
          //       _controller.fetchNextPage();
          //     }
          //   },
          // )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: amityFollowRelationships.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: amityFollowRelationships.length,
                      itemBuilder: (context, index) {
                        final amityFollowRelationship =
                            amityFollowRelationships[index];
                        return Container(
                          child: Text(
                              '${amityFollowRelationship.sourceUserId}_${amityFollowRelationship.targetUserId}'),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Followers'),
                  ),
          ),
          if (_controller.isFetching && amityFollowRelationships.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
