import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class StoryTargetWidget extends StatefulWidget {
  final AmityStoryTargetType targetType;
  final String targetId;
  const StoryTargetWidget(
      {super.key, required this.targetType, required this.targetId});

  @override
  State<StoryTargetWidget> createState() => _StoryTargetWidgetState();
}

class _StoryTargetWidgetState extends State<StoryTargetWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AmityStoryTarget>(
        stream: AmitySocialClient.newStoryRepository().live.getStoryTaregt(targetType: widget.targetType, targetId: widget.targetId),
        builder: (context, snapshot) {
          print("StoryTargetWidget ${snapshot.data?.getSyncingStoriesCount()}");
          if (snapshot.hasData) {
            return SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(
                      "Syncing Stories for ${snapshot.data?.getSyncingStoriesCount() ?? 0}"),
                  Text(
                      "Failed Stories for ${snapshot.data?.getFailedStoriesCount()?? 0}"),
                  Text("Has Unseen ${snapshot.data!.hasUnseen}"),
                ],
              ),
            );
          }else if(snapshot.connectionState==ConnectionState.waiting ){
            return const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const  SizedBox(
            height: 100,
            child: Center(
              child: Text("No Data"),
            ),
          );
        });
  }
}
