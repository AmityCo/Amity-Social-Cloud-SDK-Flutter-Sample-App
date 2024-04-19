import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/story_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GetStoriesByTargetsScreen extends StatefulWidget {
  final String targets;
  final bool showAppBar;
  const GetStoriesByTargetsScreen({
    super.key,
    required this.targets,
    this.showAppBar = true,
  });

  @override
  State<GetStoriesByTargetsScreen> createState() =>
      _GetStoriesByTargetsScreenState();
}

class _GetStoriesByTargetsScreenState extends State<GetStoriesByTargetsScreen> {
  List<StoryTargetSearchInfo> storyTargetSearchInfos = [];
  List<AmityStory> amityStories = <AmityStory>[];
  // late StoryLive
  late StoryLiveCollection storyLiveCollection;
  AmityStorySortingOrder _sortOption = AmityStorySortingOrder.LAST_CREATED;
  // StoryLiveCollection

  @override
  void initState() {
    var splitTargets = widget.targets.split(',');
    print("splitTargets: $splitTargets");
    for (var target in splitTargets) {
      var splitedTarget = target.split('/');
      print("splitedTarget: $splitedTarget");
      storyTargetSearchInfos.add(StoryTargetSearchInfo(
          targetType: AmityStoryTargetTypeExtension.enumOf(splitedTarget[0]),
          targetId: splitedTarget[1]));
    }
    storyLiveCollectionInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: const Text('Get Stories By Targets Screen'))
          : null,
      body: Column(
        children: [
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
                            disableAction: false,
                            targetType: amityStory.targetType!,
                            targetId: amityStory.targetId!,
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

  void storyLiveCollectionInit() {
    storyLiveCollection = StoryLiveCollection(
        request: () => AmitySocialClient.newStoryRepository()
            .getStoriesByTargets(
                targets: storyTargetSearchInfos, orderBy: _sortOption)
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
}
