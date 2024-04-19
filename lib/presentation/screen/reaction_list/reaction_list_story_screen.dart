import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/reaction_widget.dart';

class ReactionListStoryScreen extends StatefulWidget {
  final String referenceId;
  const ReactionListStoryScreen({super.key, required this.referenceId});

  @override
  State<ReactionListStoryScreen> createState() =>
      _ReactionListStoryScreenState();
}

class _ReactionListStoryScreenState extends State<ReactionListStoryScreen> {
  List<AmityReaction> amityReactions = <AmityReaction>[];
  late ReactionLiveCollection reactionLiveCollection;

  final scrollcontroller = ScrollController();
  bool loading = false;

  @override
  void initState() {
    reactionLiveCollection = AmitySocialClient.newReactionRepository()
        .getReactions(
            AmityStoryReactionReference(referenceId: widget.referenceId))
        .getLiveCollection();

    reactionLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityReactions = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reactionLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        reactionLiveCollection.hasNextPage()) {
      setState(() {
        reactionLiveCollection.loadNext();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Reactions')),
      body: Column(
        children: [
          Expanded(
            child: amityReactions.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      reactionLiveCollection.reset();
                      reactionLiveCollection.loadNext();
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
                    child: reactionLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (reactionLiveCollection.isFetching && amityReactions.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
