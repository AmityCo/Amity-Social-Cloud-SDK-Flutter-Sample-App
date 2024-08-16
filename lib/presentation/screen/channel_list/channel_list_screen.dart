import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/channel_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:go_router/go_router.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late ChannelLiveCollection _channelLiveCollection;
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

  @override
  void initState() {
    resetLiveCollection(isReset: false);
    scrollcontroller.addListener(pagination);
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

  void resetLiveCollection({ bool isReset = true }) async {
    if (isReset) {
      _channelLiveCollection.getStreamController().stream;
      setState(() {
        amityChannels = [];
      });
    }

    _channelLiveCollection = AmityChatClient.newChannelRepository()
      .getChannels()
      .withKeyword(_keyboard.isEmpty ? null : _keyboard)
      .sortBy(_sort)
      .filter(_filter)
      .types(_type)
      .includingTags(_tags ?? [])
      .excludingTags(_excludingTags ?? [])
      .includeDeleted(false)
      .getLiveCollection();

    _channelLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityChannels = event;
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
      appBar: AppBar(title: const Text('Channel List ')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              onChanged: (value) {
                _debouncer.run(() {
                  _keyboard = value;
                  resetLiveCollection();
                });
              },
              decoration: const InputDecoration(hintText: 'Enter Keybaord'),
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child: Text(AmityChannelFilter.ALL.name),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(AmityChannelFilter.MEMBER.name),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Text(AmityChannelFilter.NOT_MEMBER.name),
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    onSelected: (index) async {
                      if (index == 1) {
                        _filter = AmityChannelFilter.ALL;
                      }
                      if (index == 2) {
                        _filter = AmityChannelFilter.MEMBER;
                      }
                      if (index == 3) {
                        _filter = AmityChannelFilter.NOT_MEMBER;
                      }
                      resetLiveCollection();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        CheckedPopupMenuItem(
                          value: 0,
                          checked: _type.isEmpty,
                          child: const Text('ALL'),
                        ),
                        CheckedPopupMenuItem(
                          value: 1,
                          checked: _type.contains(AmityChannelType.COMMUNITY),
                          child: Text(AmityChannelType.COMMUNITY.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 2,
                          checked: _type.contains(AmityChannelType.LIVE),
                          child: Text(AmityChannelType.LIVE.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 3,
                          checked: _type.contains(AmityChannelType.BROADCAST),
                          child: Text(AmityChannelType.BROADCAST.value),
                        ),
                        CheckedPopupMenuItem(
                          value: 4,
                          checked:
                              _type.contains(AmityChannelType.CONVERSATION),
                          child: Text(AmityChannelType.CONVERSATION.value),
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.file_present_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 0) {
                        _type.clear();
                      }

                      if (index == 1) {
                        if (_type.contains(AmityChannelType.COMMUNITY)) {
                          _type.remove(AmityChannelType.COMMUNITY);
                        } else {
                          _type.add(AmityChannelType.COMMUNITY);
                        }
                      }
                      if (index == 2) {
                        if (_type.contains(AmityChannelType.LIVE)) {
                          _type.remove(AmityChannelType.LIVE);
                        } else {
                          _type.add(AmityChannelType.LIVE);
                        }
                      }
                      if (index == 3) {
                        if (_type.contains(AmityChannelType.BROADCAST)) {
                          _type.remove(AmityChannelType.BROADCAST);
                        } else {
                          _type.add(AmityChannelType.BROADCAST);
                        }
                      }
                      if (index == 4) {
                        if (_type.contains(AmityChannelType.CONVERSATION)) {
                          _type.remove(AmityChannelType.CONVERSATION);
                        } else {
                          _type.add(AmityChannelType.CONVERSATION);
                        }
                      }
                      resetLiveCollection();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child:
                              Text(AmityChannelSortOption.LAST_ACTIVITY.name),
                        ),
                      ];
                    },
                    child: const Icon(
                      Icons.sort_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _sort = AmityChannelSortOption.LAST_ACTIVITY;
                      }
                      resetLiveCollection();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.tag, size: 18),
                    onTap: () {
                      EditTextDialog.show(context,
                          title: 'Enter tags, separate by comma',
                          hintText: 'type tags here', onPress: (value) {
                        if (value.isNotEmpty) {
                          _tags = value.trim().split(',');
                        }
                        if (value.isEmpty) {
                          _tags = [];
                        }
                        resetLiveCollection();
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.tag, size: 18),
                    onTap: () {
                      EditTextDialog.show(context,
                          title: 'Enter excluding tags, separate by comma',
                          hintText: 'type tags here', onPress: (value) {
                        if (value.isNotEmpty) {
                          _excludingTags = value.trim().split(',');
                        }
                        if (value.isEmpty) {
                          _excludingTags = [];
                        }
                        resetLiveCollection();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
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
                    child: _channelLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_channelLiveCollection.isFetching && amityChannels.isNotEmpty)
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
