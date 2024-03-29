import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/reaction_widget.dart';

class ReactionListMessageScreen extends StatefulWidget {
  const ReactionListMessageScreen({Key? key, required this.messageId})
      : super(key: key);
  final String messageId;
  @override
  State<ReactionListMessageScreen> createState() =>
      _ReactionListMessageScreenState();
}

class _ReactionListMessageScreenState extends State<ReactionListMessageScreen> {
  late PagingController<AmityReaction> _controller;
  final amityReactions = <AmityReaction>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityChatClient.newMessageRepository()
          .getReaction(messageId: widget.messageId)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityReactions.clear();
              amityReactions.addAll(_controller.loadedItems);
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
      appBar: AppBar(title: Text('Message Reactions - ${widget.messageId}')),
      body: Column(
        children: [
          Expanded(
            child: amityReactions.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityReactions.length,
                      itemBuilder: (context, index) {
                        final amityReaction = amityReactions[index];
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 12),
                          child: ReactionWidget(
                            reaction: amityReaction,
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
          if (_controller.isFetching && amityReactions.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
