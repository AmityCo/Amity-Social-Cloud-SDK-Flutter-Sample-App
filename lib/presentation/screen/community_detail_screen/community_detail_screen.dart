import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/community_live_object_widget.dart';

class CommunityDetailScreen extends StatefulWidget {
  const CommunityDetailScreen({Key? key, required this.communityId}) : super(key: key);
  final String communityId;
  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Detail - ${widget.communityId}'),
      ),
      body: 
        CommunityLiveObjectWidget(
          communityId: widget.communityId,
        ),
    );
  }
}
