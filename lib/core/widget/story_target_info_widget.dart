import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StoryTargetInfo extends StatelessWidget {
  final AmityStoryTarget amityStorytarget;
  const StoryTargetInfo({super.key , required this.amityStorytarget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Public Target Id : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.targetPublicId ?? 0}"),
            ],
          ),
          Row(
            children: [
              const Text(
                "Target type  : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.targetType.value ?? 0}"),
            ],
          ),
          Row(
            children: [
              const Text(
                "Target Type Id  : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.targetId ?? 0}"),
            ],
          ),
          Row(
            children: [
              const Text(
                "Syncing Stories  : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.getSyncingStoriesCount() ?? 0}"),
            ],
          ),
          Row(
            children: [
              const Text(
                "Failed Stories  : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.getFailedStoriesCount() ?? 0}"),
            ],
          ),
          Row(
            children: [
              const Text(
                "Has Unseen  : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${amityStorytarget.hasUnseen}"),
            ],
          ),


          const Divider()
        ],
      ),
    );
  }
}
