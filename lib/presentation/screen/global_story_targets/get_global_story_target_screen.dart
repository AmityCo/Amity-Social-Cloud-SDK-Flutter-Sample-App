import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_social_sample_app/core/widget/story_target_info_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GlobalStoryTargetScreen extends StatefulWidget {
  const GlobalStoryTargetScreen({super.key});

  @override
  State<GlobalStoryTargetScreen> createState() =>
      _GlobalStoryTargetScreenState();
}

class _GlobalStoryTargetScreenState extends State<GlobalStoryTargetScreen> {
  var selectedType = AmityGlobalStoryTargetsQueryOption.SMART;

  late GlobalStoryTargetLiveCollection liveCollection;
  List<AmityStoryTarget> storyTargets = [];
  final scrollcontroller = ScrollController();

  @override
  void initState() {
    globalStoryTargetsLiveCollectionInit();
    super.initState();
  }

  void globalStoryTargetsLiveCollectionInit() {
    liveCollection = GlobalStoryTargetLiveCollection(queryOption: selectedType);

    liveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          storyTargets = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      liveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

  }

  void pagination() {
    if ((scrollcontroller.position.pixels == (scrollcontroller.position.maxScrollExtent)) &&
        liveCollection.hasNextPage()) {
      liveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Story Traget')),
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
                          value: 1,
                          checked: selectedType.value ==
                              AmityGlobalStoryTargetsQueryOption.ALL.value,
                          child: Text(
                              AmityGlobalStoryTargetsQueryOption.ALL.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 2,
                          checked: selectedType.value ==
                              AmityGlobalStoryTargetsQueryOption.SEEN.value,
                          child: Text(
                              AmityGlobalStoryTargetsQueryOption.SEEN.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 3,
                          checked: selectedType.value ==
                              AmityGlobalStoryTargetsQueryOption.UNSEEN.value,
                          child: Text(
                              AmityGlobalStoryTargetsQueryOption.UNSEEN.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 4,
                          checked: selectedType.value ==
                              AmityGlobalStoryTargetsQueryOption.SMART.value,
                          child: Text(
                              AmityGlobalStoryTargetsQueryOption.SMART.value),
                        )
                      ];
                    },
                    onSelected: (value) {
                      if (value == 1) {
                        selectedType = AmityGlobalStoryTargetsQueryOption.ALL;
                      } else if (value == 2) {
                        selectedType = AmityGlobalStoryTargetsQueryOption.SEEN;
                      } else if (value == 3) {
                        selectedType =
                            AmityGlobalStoryTargetsQueryOption.UNSEEN;
                      } else if (value == 4) {
                        selectedType = AmityGlobalStoryTargetsQueryOption.SMART;
                      }
                      liveCollection.reset();
                      globalStoryTargetsLiveCollectionInit();
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: storyTargets.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      liveCollection.reset();
                      globalStoryTargetsLiveCollectionInit();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      shrinkWrap: true,
                      itemCount: storyTargets.length,
                      itemBuilder: (context, index) {
                        final storyTarget = storyTargets[index];
                        var uniqueKey = UniqueKey();
                        return VisibilityDetector(
                          key: uniqueKey,
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (info.visibleFraction > 0) {
                              // amityPost.analytics().markPostAsViewed();
                            }
                          },
                          child: StoryTargetInfo(
                            key: uniqueKey,
                            amityStorytarget: storyTarget
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: liveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Story Target'),
                  ),
          ),
          if (liveCollection.isFetching && storyTargets.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        
        ],
      ),
    );
  }
}
