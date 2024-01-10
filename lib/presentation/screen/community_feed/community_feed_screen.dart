import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:get/utils.dart';

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
  // late PagingController<AmityPost> _controller;
  List<AmityPost> amityPosts = <AmityPost>[];
  late PostLiveCollection postLiveCollection;
  AmityCommunity? _amityCommunity;
  final scrollcontroller = ScrollController();
  bool loading = false;
  AmityPostSortOption _sortOption = AmityPostSortOption.LAST_CREATED;
  final List<AmityDataType> _dataType = [];
  List<String> _tags = [];

  @override
  void initState() {
    postLiveCollection = PostLiveCollection(
        request: () => AmitySocialClient.newPostRepository()
            .getPosts()
            .targetCommunity(widget.communityId)
            .feedType(AmityFeedType.PUBLISHED)
            .includeDeleted(false)
            .types(_dataType)
            .tags(_tags)
            .sortBy(_sortOption)
            .onlyParent(true)
            .build());

    postLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityPosts = event;
        });
      }
    });

    AmitySocialClient.newCommunityRepository()
        .getCommunity(widget.communityId)
        .then((value) {
      _amityCommunity = value;
      _amityCommunity!
          .subscription(AmityCommunityEvents.values[1])
          .subscribeTopic()
          .then((value) {})
          .onError((error, stackTrace) {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

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
  void dispose() {
    _amityCommunity!
        .subscription(AmityCommunityEvents.values[1])
        .unsubscribeTopic()
        .then((value) {})
        .onError((error, stackTrace) {});
    super.dispose();
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
                      postLiveCollection.getFirstPageRequest();
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
                      postLiveCollection.getFirstPageRequest();
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
                        postLiveCollection.reset();
                        postLiveCollection.getFirstPageRequest();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Text("Size of posts: ${amityPosts.length}"),
          Expanded(
            child: amityPosts.isNotEmpty
                ? RefreshIndicator(
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
                          communityId: widget.communityId,
                          amityPost: amityPost,
                          isPublic: widget.isPublic,
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: postLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (postLiveCollection.isFetching && amityPosts.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
