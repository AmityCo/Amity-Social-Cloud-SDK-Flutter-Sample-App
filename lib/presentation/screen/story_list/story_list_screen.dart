import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/story_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StoryListScreen extends StatefulWidget {
  final AmityStoryTargetType targetType;
  final String targetId;
  final bool showAppBar;
  final AmityCommunity amityCommunity;
  const StoryListScreen(
      {super.key,
      required this.targetType,
      required this.targetId,
      this.showAppBar = true,
      required this.amityCommunity});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  List<AmityStory> amityStories = <AmityStory>[];
  // late StoryLive
  late StoryLiveCollection storyLiveCollection;
  AmityStorySortingOrder _sortOption = AmityStorySortingOrder.LAST_CREATED;
  // StoryLiveCollection

  @override
  void initState() {
    storyLiveCollectionInit();
    widget.amityCommunity
        .subscription(AmityCommunityEvents.STORIES_AND_COMMENTS)
        .subscribeTopic()
        .then((value) {})
        .onError((error, stackTrace) {});

    super.initState();
  }

  @override
  void dispose() {
    widget.amityCommunity
        .subscription(AmityCommunityEvents.STORIES_AND_COMMENTS)
        .unsubscribeTopic()
        .then((value) {})
        .onError((error, stackTrace) {});
    super.dispose();
  }

  void storyLiveCollectionInit() {
    storyLiveCollection = StoryLiveCollection(
        request:  ()=> AmitySocialClient.newStoryRepository()
            .getActiveStories(
                targetId: widget.targetId,
                targetType: widget.targetType,
                orderBy: _sortOption)
            .build());

    storyLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityStories = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storyLiveCollection.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text('${widget.targetType.value} - ${widget.targetId}'))
          : null,
      body: Column(
        children: [
          Text("Size of posts: ${amityStories.length}"),
          Container(
            padding: const EdgeInsets.all(8),
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 2,
                    child: Text(AmityStorySortingOrder.FIRST_CREATED.name),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text(AmityStorySortingOrder.LAST_CREATED.name),
                  )
                ];
              },
              child: const Icon(
                Icons.sort_rounded,
                size: 18,
              ),
              onSelected: (index) {
                if (index == 2) {
                  _sortOption = AmityStorySortingOrder.FIRST_CREATED;
                }
                if (index == 3) {
                  _sortOption = AmityStorySortingOrder.LAST_CREATED;
                }

                storyLiveCollection.reset();
                storyLiveCollectionInit();
              },
            ),
          ),
          Expanded(
            child: amityStories.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      storyLiveCollection.reset();
                      storyLiveCollectionInit();
                    },
                    child: ListView.builder(
                      itemCount: amityStories.length,
                      itemBuilder: (context, index) {
                        final amityStory = amityStories[index];
                        print("amityStory: ${amityStory.createdAt?.hour}:${amityStory.createdAt?.minute}:${amityStory.createdAt?.second}");
                        var uniqueKey = UniqueKey();
                        return VisibilityDetector(
                          key: uniqueKey,
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (info.visibleFraction > 0) {
                              // amityPost.analytics().markPostAsViewed();
                            }
                          },
                          child: StoryWidget(
                            key: uniqueKey,
                            story: amityStory,
                            disableAction: false ,
                            targetType: widget.targetType,
                            targetId: widget.targetId,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: storyLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (storyLiveCollection.isFetching && amityStories.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
