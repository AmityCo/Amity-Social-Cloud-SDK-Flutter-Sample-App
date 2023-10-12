import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

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
    controller = AmityVideoContoller(stream: widget.stream);
  }

  @override
  Widget build(BuildContext context) {
    return AmityVideoPlayer(controller: controller);
  }
}