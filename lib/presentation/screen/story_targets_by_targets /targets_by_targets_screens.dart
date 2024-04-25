import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GetStoryTargetsByTargets extends StatefulWidget {
  final String targets;
  final bool showAppBar;
  const GetStoryTargetsByTargets(
      {super.key, required this.targets, this.showAppBar = true});

  @override
  State<GetStoryTargetsByTargets> createState() =>
      _GetStoryTargetsByTargetsState();
}

class _GetStoryTargetsByTargetsState extends State<GetStoryTargetsByTargets> {
  List<StoryTargetSearchInfo> storyTargetSearchInfos = [];
  List<AmityStoryTarget> amityStorytargets = <AmityStoryTarget>[];
  // late StoryTargetLive
  late StoryTargetLiveCollection storyTargetLiveCollection;

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
    storyTargetsLiveCollectionInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: const Text('Get Story Target By Targets Screen'))
          : null,
      body: Column(
        children: [
          Expanded(
            child: amityStorytargets.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      storyTargetLiveCollection.reset();
                      storyTargetsLiveCollectionInit();
                    },
                    child: ListView.builder(
                      itemCount: amityStorytargets.length,
                      itemBuilder: (context, index) {
                        final amityStorytarget = amityStorytargets[index];
                        var uniqueKey = UniqueKey();
                        return VisibilityDetector(
                          key: uniqueKey,
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (info.visibleFraction > 0) {
                              // amityPost.analytics().markPostAsViewed();
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Target Unique Id (Local)  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${amityStorytarget.uniqueId ?? 0}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Target type  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${amityStorytarget.targetType.value ?? 0}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Target Type Id  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${amityStorytarget.getSyncingStoriesCount() ?? 0}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Syncing Stories  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${amityStorytarget.getSyncingStoriesCount() ?? 0}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Failed Stories  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${amityStorytarget.getFailedStoriesCount() ?? 0}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Has Unseen  : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("${amityStorytarget.hasUnseen}"),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: storyTargetLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (storyTargetLiveCollection.isFetching &&
              amityStorytargets.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  void storyTargetsLiveCollectionInit() {
    storyTargetLiveCollection = StoryTargetLiveCollection(
        request: () => AmitySocialClient.newStoryRepository()
            .getStoryTargets(targets: storyTargetSearchInfos));

    storyTargetLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityStorytargets = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storyTargetLiveCollection.getData();
    });
  }
}
