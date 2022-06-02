import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:go_router/go_router.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({Key? key, required this.userId, this.showAppBar = true})
      : super(key: key);
  final String userId;
  final bool showAppBar;
  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  late PagingController<AmityPost> _controller;
  final amityPosts = <AmityPost>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityUserFeedSortOption _sortOption = AmityUserFeedSortOption.LAST_CREATED;
  List<AmityDataType> _dataType = [];

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getUserFeed(widget.userId)
          .includeDeleted(false)
          .sortBy(_sortOption)
          .types(_dataType)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityPosts.clear();
              amityPosts.addAll(_controller.loadedItems);
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
      appBar: widget.showAppBar
          ? AppBar(title: Text('User Feed - ${widget.userId}'))
          : null,
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   child: PopupMenuButton(
                //     itemBuilder: (context) {
                //       return [
                //         CheckedPopupMenuItem(
                //           child: Text(AmityDataType.IMAGE.name),
                //           value: 2,
                //           checked: _dataType.contains(AmityDataType.IMAGE),
                //         ),
                //         CheckedPopupMenuItem(
                //           child: Text(AmityDataType.VIDEO.name),
                //           value: 3,
                //           checked: _dataType.contains(AmityDataType.VIDEO),
                //         ),
                //         CheckedPopupMenuItem(
                //           child: Text(AmityDataType.FILE.name),
                //           value: 4,
                //           checked: _dataType.contains(AmityDataType.FILE),
                //         )
                //       ];
                //     },
                //     child: const Icon(
                //       Icons.filter_alt_rounded,
                //       size: 18,
                //     ),
                //     onSelected: (index) {
                //       if (index == 1) {
                //         _dataType.clear();
                //       }
                //       if (index == 2) {
                //         if (_dataType.contains(AmityDataType.IMAGE)) {
                //           _dataType.remove(AmityDataType.IMAGE);
                //         } else {
                //           _dataType.add(AmityDataType.IMAGE);
                //         }
                //       }
                //       if (index == 3) {
                //         if (_dataType.contains(AmityDataType.VIDEO)) {
                //           _dataType.remove(AmityDataType.VIDEO);
                //         } else {
                //           _dataType.add(AmityDataType.VIDEO);
                //         }
                //       }
                //       if (index == 4) {
                //         if (_dataType.contains(AmityDataType.FILE)) {
                //           _dataType.remove(AmityDataType.FILE);
                //         } else {
                //           _dataType.add(AmityDataType.FILE);
                //         }
                //       }

                //       _controller.reset();
                //       _controller.fetchNextPage();
                //     },
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child:
                              Text(AmityUserFeedSortOption.FIRST_CREATED.name),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child:
                              Text(AmityUserFeedSortOption.LAST_CREATED.name),
                          value: 3,
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.sort_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 2) {
                        _sortOption = AmityUserFeedSortOption.FIRST_CREATED;
                      }
                      if (index == 3) {
                        _sortOption = AmityUserFeedSortOption.LAST_CREATED;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: amityPosts.isNotEmpty
                ? RefreshIndicator(
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
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_controller.isFetching && amityPosts.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
