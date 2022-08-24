import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/add_message_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/message_widget.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    messageLiveCollection = AmityChatClient.newMessageRepository()
        .getMessages(widget.channelId)
        .stackFromEnd(true)
        .getLiveCollection(pageSize: 20)
      ..onError((error, stacktrac) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: Text('${error.toString()}'),
                title: Text('Error'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: Text('Back'))
                ],
              );
            });
      });

    messageLiveCollection.asStream().listen((event) {
      print(event.map((e) => "${e.channelSegment}, ").toList());
      setState(() {
        if (mounted) amityMessages = event;
      });
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
      body: SafeArea(
        child: Column(
          children: [
            if (messageLiveCollection.isFetching)
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
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MessageWidget(message: message),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: AddMessageWidget(
                AmityCoreClient.getCurrentUser(),
                (text) async {
                  await AmityChatClient.newMessageRepository()
                      .createMessage(widget.channelId)
                      .text(text)
                      .send()
                      .then((value) {
                    scrollcontroller.jumpTo(0);
                  }).onError((error, stackTrace) {
                    CommonSnackbar.showNagativeSnackbar(
                        context, 'Error', error.toString());
                  });
                  // _controller.addAtIndex(0, _comment);
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
