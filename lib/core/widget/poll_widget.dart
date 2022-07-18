import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/extension/duration_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';

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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
          border: Border.all(color: Colors.grey.withOpacity(.5))),
      child: FutureBuilder<AmityPoll>(
        future: widget.data.getPoll(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final value = snapshot.data;
            // print(DateTime.now().toUtc().toIso8601String());
            // print(value!.closedAt!.toIso8601String());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      value!.answers!.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () {
                            AmitySocialClient.newPollRepository().vote(
                              pollId: value.pollId!,
                              answerIds: [value.answers![index].id!],
                            ).then((value) {
                              print(value);
                            }).onError((error, stackTrace) {
                              CommonSnackbar.showNagativeSnackbar(
                                  context, 'Error', error.toString());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       error.toString(),
                              //     ),
                              //     backgroundColor: Colors.red,
                              //   ),
                              // );
                            });
                          },
                          child: VoteCountWidget(
                            title: value.answers![index].data ?? '',
                            votePrecentile: 0,
                            voteCount: value.answers![index].voteCount ?? 0,
                            isMyVote:
                                value.answers![index].isVotedByUser ?? false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                    '${snapshot.data!.totalVote} Votes \u2022  ${snapshot.data!.isClose ? 'Poll Closed' : snapshot.data!.closedAt!.difference(DateTime.now().toUtc()).readableString() + ' left'}')
              ],
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
      this.isMyVote = false,
      this.showResult = false})
      : super(key: key);
  final String title;
  final double votePrecentile;
  final int voteCount;
  final bool isMyVote;
  final bool showResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text('  $voteCount Votes', style: Theme.of(context).textTheme.caption)
        ],
      ),
    );
  }
}

 // Container(
          //   height: 12,
          //   width: double.maxFinite,
          //   alignment: Alignment.centerLeft,
          //   margin: const EdgeInsets.symmetric(vertical: 6),
          //   decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(4)),
          //       color: Colors.black26),
          //   child: LayoutBuilder(
          //     builder: (context, constraints) {
          //       return Container(
          //         width: constraints.maxWidth * 0.5,
          //         decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.all(Radius.circular(4)),
          //             color: Colors.blue),
          //       );
          //     },
          //   ),
          // ),
          // Text('$voteCount Votes')
