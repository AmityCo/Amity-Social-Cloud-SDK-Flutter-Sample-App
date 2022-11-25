import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/add_message_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.channelId}) : super(key: key);
  final String channelId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PagingController<AmityMessage> _controller;
  List<AmityMessage> amityMessages = [];
  final scrollcontroller = ScrollController();

  AmityMessageDataType? _type;
  AmityChannelSortOption _sort = AmityChannelSortOption.LAST_ACTIVITY;
  List<String>? _tags;
  List<String>? _excludingTags;

  @override
  void initState() {
    // final builder =
    //     AmityChatClient.newMessageRepository().getMessages(widget.channelId);
    // // .type(_type)
    // _controller = builder.stackFromEnd(true).getLiveCollection(pageSize: 20)
    //   ..onError((error, stacktrace) {
    //     print(stacktrace.toString());
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) {
    //           return AlertDialog(
    //             content: Text('${error.toString()}'),
    //             title: Text('Error'),
    //             actions: [
    //               ElevatedButton(
    //                   onPressed: () {
    //                     GoRouter.of(context).pop();
    //                   },
    //                   child: Text('Back'))
    //             ],
    //           );
    //         });
    //   });

    // _controller.getStreamController().stream.listen((event) {
    //   //   print(event.map((e) => "${e.channelSegment}, ").toList());
    //   if (mounted) {
    //     setState(() {
    //       amityMessages = event;
    //     });
    //   }
    // });

    _controller = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getMessages(widget.channelId)
          .stackFromEnd(false)
          .type(_type)
          .includingTags(_tags ?? [])
          .excludingTags(_excludingTags ?? [])
          .includeDeleted(false)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityMessages.clear();
              amityMessages.addAll(_controller.loadedItems);
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

    // _controller.asStream().onListen((event) {
    //   print(event.map((e) => "${e.channelSegment}, ").toList());
    //   if (mounted) {
    //     setState(() {
    //       amityMessages = event;
    //     });
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels >=
            (scrollcontroller.position.maxScrollExtent - 100)) &&
        _controller.hasMoreItems) {
      _controller.fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: PopupMenuButton<int>(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text(AmityMessageDataType.TEXT.value),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text(AmityMessageDataType.IMAGE.value),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text(AmityMessageDataType.FILE.value),
                            value: 2,
                          ),
                          PopupMenuItem(
                            child: Text(AmityMessageDataType.AUDIO.value),
                            value: 3,
                          ),
                          PopupMenuItem(
                            child: Text(AmityMessageDataType.CUSTOM.value),
                            value: 4,
                          ),
                          const PopupMenuItem(
                            child: Text('All'),
                            value: 5,
                          )
                        ];
                      },
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        size: 18,
                      ),
                      onSelected: (index) {
                        if (index != 5) {
                          _type = AmityMessageDataType.values[index];
                        } else {
                          _type = null;
                        }

                        _controller.reset();
                        _controller.fetchNextPage();
                      },
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   child: PopupMenuButton(
                  //     itemBuilder: (context) {
                  //       return [
                  //         CheckedPopupMenuItem(
                  //           child: const Text('ALL'),
                  //           value: 0,
                  //           checked: _type.isEmpty,
                  //         ),
                  //         CheckedPopupMenuItem(
                  //           child: Text(AmityChannelType.COMMUNITY.value),
                  //           value: 1,
                  //           checked: _type.contains(AmityChannelType.COMMUNITY),
                  //         ),
                  //         CheckedPopupMenuItem(
                  //           child: Text(AmityChannelType.LIVE.value),
                  //           value: 2,
                  //           checked: _type.contains(AmityChannelType.LIVE),
                  //         ),
                  //         CheckedPopupMenuItem(
                  //           child: Text(AmityChannelType.BROADCAST.value),
                  //           value: 3,
                  //           checked: _type.contains(AmityChannelType.BROADCAST),
                  //         ),
                  //         CheckedPopupMenuItem(
                  //           child: Text(AmityChannelType.CONVERSATION.value),
                  //           value: 4,
                  //           checked:
                  //               _type.contains(AmityChannelType.CONVERSATION),
                  //         )
                  //       ];
                  //     },
                  //     child: const Icon(
                  //       Icons.file_present_rounded,
                  //       size: 18,
                  //     ),
                  //     onSelected: (index) {
                  //       if (index == 0) {
                  //         _type.clear();
                  //       }

                  //       if (index == 1) {
                  //         if (_type.contains(AmityChannelType.COMMUNITY)) {
                  //           _type.remove(AmityChannelType.COMMUNITY);
                  //         } else {
                  //           _type.add(AmityChannelType.COMMUNITY);
                  //         }
                  //       }
                  //       if (index == 2) {
                  //         if (_type.contains(AmityChannelType.LIVE)) {
                  //           _type.remove(AmityChannelType.LIVE);
                  //         } else {
                  //           _type.add(AmityChannelType.LIVE);
                  //         }
                  //       }
                  //       if (index == 3) {
                  //         if (_type.contains(AmityChannelType.BROADCAST)) {
                  //           _type.remove(AmityChannelType.BROADCAST);
                  //         } else {
                  //           _type.add(AmityChannelType.BROADCAST);
                  //         }
                  //       }
                  //       if (index == 4) {
                  //         if (_type.contains(AmityChannelType.CONVERSATION)) {
                  //           _type.remove(AmityChannelType.CONVERSATION);
                  //         } else {
                  //           _type.add(AmityChannelType.CONVERSATION);
                  //         }
                  //       }

                  //       _controller.reset();
                  //       _controller.loadNext();
                  //     },
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   child: PopupMenuButton(
                  //     itemBuilder: (context) {
                  //       return [
                  //         PopupMenuItem(
                  //           child:
                  //               Text(AmityChannelSortOption.LAST_ACTIVITY.name),
                  //           value: 1,
                  //         ),
                  //       ];
                  //     },
                  //     child: const Icon(
                  //       Icons.sort_rounded,
                  //       size: 18,
                  //     ),
                  //     onSelected: (index) {
                  //       if (index == 1) {
                  //         _sort = AmityChannelSortOption.LAST_ACTIVITY;
                  //       }

                  //       _controller.reset();
                  //       _controller.loadNext();
                  //     },
                  //   ),
                  // ),
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
            if (_controller.isFetching)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                controller: scrollcontroller,
                itemCount: amityMessages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = amityMessages[index];
                  return Container(
                    // height: 120,
                    // margin: const EdgeInsets.all(12),
                    // decoration: BoxDecoration(
                    //   color: Colors.grey.shade200,
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    child: MessageWidget(message: message),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: AddMessageWidget(
                AmityCoreClient.getCurrentUser(),
                (value) async {
                  if (value.image != null) {
                    await AmityChatClient.newMessageRepository()
                        .createMessage(widget.channelId)
                        .image(Uri(path: value.image!.path))
                        .caption(value.message!)
                        .send()
                        .then((value) {
                      scrollcontroller.jumpTo(0);
                    }).onError((error, stackTrace) {
                      CommonSnackbar.showNagativeSnackbar(
                          context, 'Error', error.toString());
                    });
                    return;
                  }
                  if (value.file != null) {
                    await AmityChatClient.newMessageRepository()
                        .createMessage(widget.channelId)
                        .file(Uri(path: value.file!.path))
                        .caption(value.message!)
                        .send()
                        .then((value) {
                      scrollcontroller.jumpTo(0);
                    }).onError((error, stackTrace) {
                      CommonSnackbar.showNagativeSnackbar(
                          context, 'Error', error.toString());
                    });
                    return;
                  }
                  await AmityChatClient.newMessageRepository()
                      .createMessage(widget.channelId)
                      .text(value.message!)
                      .send()
                      .then((value) {
                    scrollcontroller.jumpTo(0);
                  }).onError((error, stackTrace) {
                    print(stackTrace.toString());
                    CommonSnackbar.showNagativeSnackbar(
                        context, 'Error', error.toString());
                  });
                  return;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
