import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({Key? key, required this.userId, this.showAppBar = true})
      : super(key: key);
  final String userId;
  final bool showAppBar;
  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  final amityPosts = <AmityPost>[];
  late PostLiveCollection postLiveCollection;

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityPostSortOption _sortOption = AmityPostSortOption.LAST_CREATED;
  final List<AmityDataType> _dataType = [];

  @override
  void initState() {
    postLiveCollection = AmitySocialClient.newPostRepository()
    .getPosts()
    .targetUser(widget.userId)
    .sortBy(_sortOption)
      .sortBy(_sortOption)
      .types(_dataType)
      .getLiveCollection();

    postLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityPosts.clear();
          amityPosts.addAll(event);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        postLiveCollection.hasNextPage()) {
      setState(() {
        postLiveCollection.loadNext();
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

                      postLiveCollection.reset();
                      postLiveCollection.loadNext();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 2,
                          child:
                              Text(AmityUserFeedSortOption.FIRST_CREATED.name),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child:
                              Text(AmityUserFeedSortOption.LAST_CREATED.name),
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

                      postLiveCollection.reset();
                      postLiveCollection.loadNext();
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
                      postLiveCollection.reset();
                      postLiveCollection.loadNext();
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
                                  if (info.visibleFraction == 1.0) {
                                    // amityPost.analytics().markPostAsViewed();
                                  }
                                },
                                child: FeedWidget(
                                  key: uniqueKey,
                                  amityPost: amityPost,
                                ),
                              );
                            },
                          )
                  )
                : Container(
                    alignment: Alignment.center,
                    child: postLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : Text('No Post'),
                  ),
          ),
          if (postLiveCollection.isFetching && amityPosts.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
