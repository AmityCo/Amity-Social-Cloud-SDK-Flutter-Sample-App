import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GlobalFeedScreen extends StatefulWidget {
  const GlobalFeedScreen({Key? key}) : super(key: key);

  @override
  State<GlobalFeedScreen> createState() => _GlobalFeedScreenState();
}

class _GlobalFeedScreenState extends State<GlobalFeedScreen> {
  late PagingController<AmityPost> _controller;
  final amityPosts = <AmityPost>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  final List<AmityDataType> _dataType = [];

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getGlobalFeed()
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
            print(_controller.stacktrace);
            ErrorDialog.show(context,
                title: 'Error',
                message: '${_controller.error}\n${_controller.stacktrace}');
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
      appBar: AppBar(title: const Text('Global Feed')),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      CheckedPopupMenuItem(
                        value: 2,
                        checked: _dataType.contains(AmityDataType.IMAGE),
                        child: Text(AmityDataType.IMAGE.name),
                      ),
                      CheckedPopupMenuItem(
                        value: 3,
                        checked: _dataType.contains(AmityDataType.VIDEO),
                        child: Text(AmityDataType.VIDEO.name),
                      ),
                      CheckedPopupMenuItem(
                        value: 4,
                        checked: _dataType.contains(AmityDataType.FILE),
                        child: Text(AmityDataType.FILE.name),
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
            ],
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
                        var uniqueKey = UniqueKey();
                        return VisibilityDetector(
                          key: uniqueKey,
                          onVisibilityChanged: (VisibilityInfo info) { 
                            if(info.visibleFraction == 1.0){
                              // amityPost.analytics().markPostAsViewed();
                            }
                           },
                          child: FeedWidget(
                            key: uniqueKey,
                            amityPost: amityPost,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Global Post'),
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
