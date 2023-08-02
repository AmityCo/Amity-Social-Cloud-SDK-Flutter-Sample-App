import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List<AmityPost> amityPosts = <AmityPost>[];
  late PostLiveCollection postLiveCollection;
  AmityPostSortOption _sortOption = AmityPostSortOption.LAST_CREATED;
  final List<AmityDataType> _dataType = [];
  final scrollcontroller = ScrollController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posts"),
      ),
      body: SafeArea(
        child: amityPosts.isEmpty
            ? Center(
                child: Text(amityPosts.isEmpty
                    ? 'No Post Found'
                    : "Something Happened"),
              )
            : Column(
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
                                  checked:
                                      _dataType.contains(AmityDataType.IMAGE),
                                  child: Text(AmityDataType.IMAGE.name),
                                ),
                                CheckedPopupMenuItem(
                                  value: 3,
                                  checked:
                                      _dataType.contains(AmityDataType.VIDEO),
                                  child: Text(AmityDataType.VIDEO.name),
                                ),
                                CheckedPopupMenuItem(
                                  value: 4,
                                  checked:
                                      _dataType.contains(AmityDataType.FILE),
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
                              setState(() {});
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
                                  child: Text(
                                      AmityPostSortOption.FIRST_CREATED.name),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Text(
                                      AmityPostSortOption.LAST_CREATED.name),
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
                              setState(() {});
                              postLiveCollection.reset();
                              postLiveCollection.loadNext();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        postLiveCollection.reset();
                        postLiveCollection.loadNext();
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
                  if (postLiveCollection.isFetching)
                    Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                ],
              ),
      ),
    );
  }

  @override
  void initState() {
    postLiveCollection = PostLiveCollection(
      request: () => AmitySocialClient.newPostRepository()
          .getPostsByLiveData()
          .targetMe()
          .onlyParent(true)
          .sortBy(_sortOption)
          .types(_dataType)
          .build(),
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
    super.initState();
  }

  void pagination() {
    if (scrollcontroller.position.atEdge &&
        scrollcontroller.position.pixels != 0 &&
        postLiveCollection.hasNextPage()) {
      postLiveCollection.loadNext();
    }
  }
}
