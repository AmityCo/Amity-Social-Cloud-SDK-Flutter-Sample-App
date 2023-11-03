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
  final scrollcontroller = ScrollController();

  @override
  void initState() {
    streamLiveCollection = StreamLiveCollection(
      request: () => AmityVideoClient.newStreamRepository()
          .getStreams()
          .status([AmityStreamStatus.recorded])
          .build(),
    );

    streamLiveCollection.getStreamController().stream.listen((event) {
      // print(event.map((e) => "${e.streamId}, ").toList());
      if (mounted) {
        setState(() {
          amityStream = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      streamLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            (scrollcontroller.position.maxScrollExtent)) &&
        streamLiveCollection.hasNextPage()) {
      streamLiveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Streams'),
      ),
      body: Scaffold(
        body: Column(
          children: [
            if (streamLiveCollection.isFetching)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            Expanded(
              child: amityStream.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text('No Stream'),
                    )
                  : ListView.builder(
                      controller: scrollcontroller,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(amityStream[index].title ?? ""),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(amityStream[index].streamId ?? ""),
                              Text(amityStream[index].status?.name ?? ""),
                              Text("User -> ${amityStream[index].user?.displayName}" ),
                            ],
                          ),
                          onTap: () {
                            GoRouter.of(context).pushNamed(AppRoute.viewStream,
                                extra: amityStream[index]);
                          },
                        );
                      },
                      itemCount: amityStream.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
