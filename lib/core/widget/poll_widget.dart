import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class PollWidget extends StatefulWidget {
  const PollWidget({Key? key, required this.data}) : super(key: key);
  final PollData data;
  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: FutureBuilder<AmityPoll>(
        future: widget.data.getPoll(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final value = snapshot.data;
            return Container(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: List.generate(
                          value!.answers!.length,
                          (index) => Container(
                                margin: const EdgeInsets.all(4),
                                child: VoteCountWidget(
                                  title: value.answers![index].data ?? '',
                                  votePrecentile: 0,
                                  voteCount:
                                      value.answers![index].voteCount ?? 0,
                                  isMyVote:
                                      value.answers![index].isVotedByUser ??
                                          false,
                                ),
                              )),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class VoteCountWidget extends StatelessWidget {
  const VoteCountWidget(
      {Key? key,
      required this.title,
      required this.votePrecentile,
      required this.voteCount,
      this.isMyVote = false})
      : super(key: key);
  final String title;
  final double votePrecentile;
  final int voteCount;
  final bool isMyVote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: Colors.black38, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            height: 12,
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.black26),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * 0.5,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.blue),
                );
              },
            ),
          ),
          Text('$voteCount Votes')
        ],
      ),
    );
  }
}
