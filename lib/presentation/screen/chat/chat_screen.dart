import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/add_message_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.channelId}) : super(key: key);
  final String channelId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MessageLiveCollection messageLiveCollection;
  List<AmityMessage> amityMessages = [];
  final scrollcontroller = ScrollController();

  AmityMessageDataType? _type;
  AmityChannelSortOption _sort = AmityChannelSortOption.LAST_ACTIVITY;
  List<String>? _tags;
  List<String>? _excludingTags;
  bool parentsOnly = false;

  AmityMessage? replyToMessage;

  @override
  void initState() {
    messageLiveCollection = MessageLiveCollection(
      request: () => AmityChatClient.newMessageRepository()
          .getMessages(widget.channelId)
          .stackFromEnd(true)
          .type(_type)
          .includingTags(_tags ?? [])
          .excludingTags(_excludingTags ?? [])
          .includeDeleted(false)
          .filterByParent(parentsOnly)
          .build(),
    );

    messageLiveCollection.getStreamController().stream.listen((event) {
      //   print(event.map((e) => "${e.channelSegment}, ").toList());
      if (mounted) {
        setState(() {
          amityMessages = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      messageLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels >=
            (scrollcontroller.position.maxScrollExtent - 100)) &&
        messageLiveCollection.hasNextPage()) {
      messageLiveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('chat_screen_key'),
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
                            value: 0,
                            child: Text(AmityMessageDataType.TEXT.value),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(AmityMessageDataType.IMAGE.value),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(AmityMessageDataType.FILE.value),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text(AmityMessageDataType.AUDIO.value),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Text(AmityMessageDataType.CUSTOM.value),
                          ),
                          const PopupMenuItem(
                            value: 5,
                            child: Text('All'),
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

                        messageLiveCollection.reset();
                        messageLiveCollection.loadNext();
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
                            defString: (_tags ?? []).join(','),
                            hintText: 'type tags here', onPress: (value) {
                          if (value.isNotEmpty) {
                            _tags = value.trim().split(',');
                          }
                          if (value.isEmpty) {
                            _tags = [];
                          }
                          messageLiveCollection.reset();
                          messageLiveCollection.loadNext();
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
                            defString: (_excludingTags ?? []).join(','),
                            hintText: 'type tags here', onPress: (value) {
                          if (value.isNotEmpty) {
                            _excludingTags = value.trim().split(',');
                          }
                          if (value.isEmpty) {
                            _excludingTags = [];
                          }
                          messageLiveCollection.reset();
                          messageLiveCollection.loadNext();
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Checkbox(
                          value: parentsOnly,
                          onChanged: (value) {
                            setState(() {
                              parentsOnly = value ?? false;
                            });
                            messageLiveCollection.reset();
                            messageLiveCollection.loadNext();
                          },
                        ),
                        const Text('Parent only')
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (messageLiveCollection.isFetching)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            Expanded(
              child: amityMessages.isEmpty
                  ? const Center(
                      child: Text('No Message'),
                    )
                  : ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityMessages.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final message = amityMessages[index];
                        return MessageWidget(
                          message: message,
                          onReplyTap: (value) => setState(() {
                            replyToMessage = value;
                          }),
                        );
                      },
                    ),
            ),
            if (replyToMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Reply to '),
                        Text('@${replyToMessage!.user!.userId}'),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              replyToMessage = null;
                            });
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                          ),
                        )
                      ],
                    ),
                    AmityMessageContentWidget(
                      amityMessage: replyToMessage!,
                    )
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.all(12),
              child: AddMessageWidget(
                widget.channelId,
                AmityCoreClient.getCurrentUser(),
                (value) async {
                  late AmityMessageCreator messageBuilder;

                  if (value.message != null) {
                    messageBuilder = AmityChatClient.newMessageRepository()
                        .createMessage(widget.channelId)
                        .text(value.message!);
                  }

                  if (value.image != null) {
                    messageBuilder = AmityChatClient.newMessageRepository()
                        .createMessage(widget.channelId)
                        .image(Uri(path: value.image!.path))
                        .caption(value.message!);
                  }

                  if (value.file != null) {
                    messageBuilder = AmityChatClient.newMessageRepository()
                        .createMessage(widget.channelId)
                        .file(Uri(path: value.file!.path))
                        .caption(value.message!);
                  }

                  if (value.amityMentionMetadata != null) {
                    messageBuilder.metadata(
                        AmityMentionMetadataCreator(value.amityMentionMetadata!)
                            .create());

                    /// Calculate the mention data
                    final userIds = <String>[];
                    for (AmityMentionMetadata amityMention
                        in value.amityMentionMetadata!) {
                      ///Check if we have channel mention and add mention channel
                      if (amityMention is AmityChannelMentionMetadata) {
                        messageBuilder.mentionChannel();
                      }
                      if (amityMention is AmityUserMentionMetadata) {
                        userIds.add(amityMention.userId);
                      }
                    }

                    ///If mention userIds is not empaty, add them to mention userIds
                    if (userIds.isNotEmpty) {
                      messageBuilder.mentionUsers(userIds);
                    }
                  }

                  if (replyToMessage != null) {
                    messageBuilder.parentId(replyToMessage!.messageId);
                  }

                  messageBuilder.send().then((value) {
                    scrollcontroller.jumpTo(0);
                    setState(() {
                      replyToMessage = null;
                    });
                  }).onError((error, stackTrace) {
                    print(error.toString());
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
