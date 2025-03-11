import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/channel_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:go_router/go_router.dart';

class ArchiveChannelListScreen extends StatefulWidget {
  const ArchiveChannelListScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveChannelListScreen> createState() => _ArchiveChannelListScreenState();
}

class _ArchiveChannelListScreenState extends State<ArchiveChannelListScreen> {
  late LiveCollectionStream<AmityChannel> _channelLiveCollection;
  List<AmityChannel> amityChannels = <AmityChannel>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyboard = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityChannelFilter _filter = AmityChannelFilter.ALL;
  final List<AmityChannelType> _type = [];
  AmityChannelSortOption _sort = AmityChannelSortOption.LAST_ACTIVITY;
  List<String>? _tags;
  List<String>? _excludingTags;
  bool? isPushNotifiable;

  @override
  void initState() {
    resetLiveCollection(isReset: false);
    scrollcontroller.addListener(pagination);
    fetchNotificationSettings();
    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _channelLiveCollection.hasNextPage()) {
      setState(() {
         _channelLiveCollection.loadNext();
      });
    }
  }

  void fetchNotificationSettings() async {
    // final settings = await AmityNotification().user().getSettings();
    // final chatModuleSetting = settings.events?.whereType<Chat>().firstOrNull;
    // setState(() {
    //   isPushNotifiable = (settings.isEnabled ?? true) && (chatModuleSetting?.isEnabled ?? true);
    // });
  }

  void resetLiveCollection({ bool isReset = true }) async {
    if (isReset) {
      await _channelLiveCollection.dispose();
      setState(() {
        amityChannels = [];
      });
    }

    _channelLiveCollection = AmityChatClient.newChannelRepository().getArchivedChannels();

    _channelLiveCollection.getStream().listen((event) {
      if (mounted) {
        setState(() {
          amityChannels = event.data;
          loading = event.isFetching;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _channelLiveCollection.loadNext();
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archived Channel List ')),
      body: Column(
        children: [
          Expanded(
            child: amityChannels.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      resetLiveCollection();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityChannels.length,
                      itemBuilder: (context, index) {
                        final amityChannel = amityChannels[index];
                        return Container(
                          margin: const EdgeInsets.all(12),
                          child: ChannelWidget(
                            amityChannel: amityChannel,
                            // onCommentCallback: () {
                            //   // GoRouter.of(context).goNamed('commentChannelFeed',
                            //   //     params: {'postId': amityPost.postId!});
                            // },
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text('No channel found'),
                  ),
          ),
          if (loading && amityChannels.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed(AppRoute.createChannel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
