import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_video_player/amity_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ViewStream extends StatefulWidget {
  final AmityStream stream;
  const ViewStream({super.key, required this.stream});

  @override
  State<ViewStream> createState() => _ViewStreamState();
}

class _ViewStreamState extends State<ViewStream> {

  late AmityVideoContoller controller;

  @override
  void initState() {
    super.initState();
    controller = AmityVideoContoller(streamId: widget.stream.streamId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmityVideoPlayer(
        controller: controller,
        onStop: () {
          GoRouter.of(context).pop();
        },
      ),
    );
  }
}