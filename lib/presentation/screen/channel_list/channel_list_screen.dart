import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/channel_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:go_router/go_router.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  late PagingController<AmityChannel> _controller;
  final amityCommunities = <AmityChannel>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyboard = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityChannelFilter _filter = AmityChannelFilter.ALL;
  List<AmityChannelType> _type = [];
  AmityChannelSortOption _sort = AmityChannelSortOption.LAST_ACTIVITY;
  List<String>? _tags;
  List<String>? _excludingTags;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityChatClient.newChannelRepository()
          .getChannels()
          .withKeyword(_keyboard.isEmpty ? null : _keyboard)
          .sortBy(_sort)
          .filter(_filter)
          .types(_type)
          .includingTags(_tags ?? [])
          .excludingTags(_excludingTags ?? [])
          .includeDeleted(false)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityCommunities.clear();
              amityCommunities.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            print(_controller.error.toString());
            print(_controller.stacktrace.toString());
            ErrorDialog.show(context,
                title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
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
              key: const Key('channel_id'),
              onChanged: (value) {
                _debouncer.run(() {
                  _keyboard = value;
                  _controller.reset();
                  _controller.fetchNextPage();
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
                          child: Text(AmityChannelFilter.ALL.name),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text(AmityChannelFilter.MEMBER.name),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text(AmityChannelFilter.NOT_MEMBER.name),
                          value: 3,
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _filter = AmityChannelFilter.ALL;
                      }
                      if (index == 2) {
                        _filter = AmityChannelFilter.MEMBER;
                      }
                      if (index == 3) {
                        _filter = AmityChannelFilter.NOT_MEMBER;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        CheckedPopupMenuItem(
                          child: const Text('ALL'),
                          value: 0,
                          checked: _type.isEmpty,
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityChannelType.COMMUNITY.value),
                          value: 1,
                          checked: _type.contains(AmityChannelType.COMMUNITY),
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityChannelType.LIVE.value),
                          value: 2,
                          checked: _type.contains(AmityChannelType.LIVE),
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityChannelType.BROADCAST.value),
                          value: 3,
                          checked: _type.contains(AmityChannelType.BROADCAST),
                        ),
                        CheckedPopupMenuItem(
                          child: Text(AmityChannelType.CONVERSATION.value),
                          value: 4,
                          checked:
                              _type.contains(AmityChannelType.CONVERSATION),
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

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child:
                              Text(AmityChannelSortOption.LAST_ACTIVITY.name),
                          value: 1,
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

                      _controller.reset();
                      _controller.fetchNextPage();
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
                        _controller.reset();
                        _controller.fetchNextPage();
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
                        _controller.reset();
                        _controller.fetchNextPage();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: amityCommunities.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityCommunities.length,
                      itemBuilder: (context, index) {
                        final amityChannel = amityCommunities[index];
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
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_controller.isFetching && amityCommunities.isNotEmpty)
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
