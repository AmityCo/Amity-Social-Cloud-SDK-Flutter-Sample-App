import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen(
      {Key? key,
      required this.communityId,
      this.showAppBar = true,
      required this.isPublic})
      : super(key: key);
  final String communityId;
  final bool isPublic;
  final bool showAppBar;
  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  late PagingController<AmityPost> _controller;
  final amityPosts = <AmityPost>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  AmityPostSortOption _sortOption = AmityPostSortOption.LAST_CREATED;
  List<AmityDataType> _dataType = [];
  List<String> _tags = [];
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newPostRepository()
          .getPosts()
          .targetCommunity(widget.communityId)
          .feedType(AmityFeedType.PUBLISHED)
          .includeDeleted(false)
          .types(_dataType)
          .tags(_tags)
          .sortBy(_sortOption)
          .onlyParent(true)
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
          ? AppBar(title: Text('Community Feed - ${widget.communityId}'))
          : null,
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        CheckedPopupMenuItem(
                          child: Text(AmityDataType.IMAGE.name),
                          value: 2,
                          checked: _dataType.contains(AmityDataType.IMAGE),
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityDataType.VIDEO.name),
                          value: 3,
                          checked: _dataType.contains(AmityDataType.VIDEO),
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityDataType.FILE.name),
                          value: 4,
                          checked: _dataType.contains(AmityDataType.FILE),
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _dataType.clear();
                      }
                      if (index == 2) {
                        if (_dataType.contains(AmityDataType.IMAGE)) {
                          _dataType.remove(AmityDataType.IMAGE);
                        } else {
                          _dataType.add(AmityDataType.IMAGE);
                        }
                      }
                      if (index == 3) {
                        if (_dataType.contains(AmityDataType.VIDEO)) {
                          _dataType.remove(AmityDataType.VIDEO);
                        } else {
                          _dataType.add(AmityDataType.VIDEO);
                        }
                      }
                      if (index == 4) {
                        if (_dataType.contains(AmityDataType.FILE)) {
                          _dataType.remove(AmityDataType.FILE);
                        } else {
                          _dataType.add(AmityDataType.FILE);
                        }
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
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
                        _sortOption = AmityPostSortOption.FIRST_CREATED;
                      }
                      if (index == 3) {
                        _sortOption = AmityPostSortOption.LAST_CREATED;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.tag, size: 18),
                    onTap: () {
                      EditTextDialog.show(context,
                          title: 'Enter tags, separate by comma',
                          hintText: 'type tags here', onPress: (value) {
                        if (value.isNotEmpty) {
                          _tags = value.trim().split(',');
                        }
                        if (value.isEmpty) {
                          _tags = [];
                        }
                        _controller.reset();
                        _controller.fetchNextPage();
                      });
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
                          communityId: widget.communityId,
                          amityPost: amityPost,
                          isPublic: widget.isPublic,
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
            )
        ],
      ),
    );
  }
}
