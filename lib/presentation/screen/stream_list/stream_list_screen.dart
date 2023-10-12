import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:go_router/go_router.dart';

class StreamListScreen extends StatefulWidget {
  const StreamListScreen({super.key});

  @override
  State<StreamListScreen> createState() => _StreamListScreenState();
}

class _StreamListScreenState extends State<StreamListScreen> {
  late StreamLiveCollection streamLiveCollection;
  List<AmityStream> amityStream = [];

  @override
  void initState() {
    streamLiveCollection = StreamLiveCollection(
      request: () =>
          AmityVideoClient.newStreamRepository().getStreams().build(),
    );

    streamLiveCollection.getStreamController().stream.listen((event) {
      print(event.map((e) => "${e.streamId}, ").toList());
      if (mounted) {
        setState(() {
          amityStream = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      streamLiveCollection.loadNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
      ),
      body: Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(amityStream[index].title ?? ""),
              subtitle: Text(amityStream[index].streamId ?? ""),
              onTap: () {
                GoRouter.of(context).goNamed(AppRoute.viewStream,
                    extra: amityStream[index]);
              },
            );
          },
          itemCount: amityStream.length,
        ),
      ),
    );
  }
}
