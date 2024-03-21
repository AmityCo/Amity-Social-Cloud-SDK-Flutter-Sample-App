import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/story_widget.dart';
import 'package:flutter_social_sample_app/core/widget/text_check_box_widget.dart';

class StoryDetailsScreen extends StatefulWidget {
  final String storyId;
  const StoryDetailsScreen({super.key, required this.storyId});

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  AmityStory? _story;
  bool _isSubscribed = false;

  @override
  void dispose() async {
    await _story!.subscription().unsubscribeTopic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Get Story by Id'),
        ),
        body: Container(
            child: Column(
          children: [
            TextCheckBox(
              title: 'Subscribe RTE',
              value: _isSubscribed,
              onChanged: (value) {
                if(value?? false){
                  _story!.subscription().subscribeTopic();
                }else{
                  _story!.subscription().unsubscribeTopic();
                }
                setState(() {
                  _isSubscribed = value??false;
                });
              },
            ),
            StreamBuilder<AmityStory>(
              stream: AmitySocialClient.newStoryRepository().live.getStory(
                    widget.storyId,
                  ),
              builder:
                  (BuildContext context, AsyncSnapshot<AmityStory> snapshot) {
                if (snapshot.hasData) {
                  final value = snapshot.data!;
                  _story = value;
                  return StoryWidget(
                    story: value,
                    targetType:
                        value.targetType ?? AmityStoryTargetType.UNKNOWN,
                    targetId: value.targetId ?? "",
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Container();
              },
            ),
          ],
        )));
  }
}
