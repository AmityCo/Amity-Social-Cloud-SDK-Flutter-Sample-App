import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/subchannel_item_widget.dart';

class SubChannelList extends StatefulWidget {
  final String channelId;
  const SubChannelList({super.key, required this.channelId});

  @override
  State<SubChannelList> createState() => _SubChannelListState();
}

class _SubChannelListState extends State<SubChannelList> {
  late SubChannelLiveCollection subChannelLiveCollection;
  List<AmitySubChannel> amitySubChannels = <AmitySubChannel>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  bool _includeDeleted = false;
  bool _excludeGeneral = true;

  @override
  void initState() {
    subChannelLiveCollectionInit();
    super.initState();
  }

  void subChannelLiveCollectionInit() {
    subChannelLiveCollection = SubChannelLiveCollection(
      request: () => AmitySocialClient.newSubChannelRepository().getSubChannels().channelId(widget.channelId).excludeMainSubChannel(_excludeGeneral).includeDeleted(_includeDeleted).build(),
    );

    subChannelLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amitySubChannels = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subChannelLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);
  }

  void pagination() {
    if ((scrollcontroller.position.pixels == (scrollcontroller.position.maxScrollExtent)) && subChannelLiveCollection.hasNextPage()) {
      subChannelLiveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    const Text('Exclude General'),
                    Checkbox(
                      value: _excludeGeneral,
                      onChanged: (bool? value) {
                        setState(() {
                          _excludeGeneral = value!;
                          subChannelLiveCollection.reset();
                          subChannelLiveCollectionInit();
                          subChannelLiveCollection.getFirstPageRequest();
                        });
                      },
                      activeColor: Colors.green, // Change the color when checked
                      checkColor: Colors.white, // Change the check mark color
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text('Include Deleted'),
                    Checkbox(
                      value: _includeDeleted,
                      onChanged: (bool? value) {
                        setState(() {
                          _includeDeleted = value!;
                          subChannelLiveCollection.reset();
                          subChannelLiveCollectionInit();
                          subChannelLiveCollection.getFirstPageRequest();
                        });
                      },
                      activeColor: Colors.green, // Change the color when checked
                      checkColor: Colors.white, // Change the check mark color
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: amitySubChannels.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        subChannelLiveCollection.reset();
                        subChannelLiveCollection.getFirstPageRequest();
                      },
                      child: ListView.builder(
                        controller: scrollcontroller,
                        itemCount: amitySubChannels.length,
                        itemBuilder: (context, index) {
                          final amitySubChannel = amitySubChannels[index];
                          print('amitySubChannel.path: ${amitySubChannel.path}');

                          var uniqueKey = UniqueKey();
                          return SubChannelItemWidget(key: uniqueKey, subChannel: amitySubChannel);
                        },
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: subChannelLiveCollection.isFetching ? const CircularProgressIndicator() : const Text('No Sub Channel'),
                    ),
            ),
            if (subChannelLiveCollection.isFetching && amitySubChannels.isNotEmpty)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
          ],
        ));
  }
}
