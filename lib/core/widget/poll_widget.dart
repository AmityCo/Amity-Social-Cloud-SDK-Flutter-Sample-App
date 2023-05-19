import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/extension/duration_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/loading_button.dart';

class PollWidget extends StatefulWidget {
  const PollWidget({Key? key, required this.data}) : super(key: key);
  final PollData data;
  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  /// incase of multiple choice answer, cache the answer.
  final answerIds = <String>[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AmityPoll>(
      future: widget.data.getPoll(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final valueFuture = snapshot.data;

          if (valueFuture?.isDeleted ?? false) {
            return Container();
          }

          return StreamBuilder<AmityPoll>(
            initialData: valueFuture!,
            stream: valueFuture.listen.stream,
            builder: (context, snapshot) {
              final value = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                  border: Border.all(
                    color: Colors.grey.withOpacity(.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          value.answers!.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () {
                                /// dont allow use to vote if he already voted
                                if (value.isVoted ?? false) {
                                  CommonSnackbar.showNagativeSnackbar(context,
                                      'Error', 'Already voted for this poll');
                                  return;
                                }

                                /// dont allow user to vote if poll is already closed.
                                if (value.isClose) {
                                  CommonSnackbar.showNagativeSnackbar(context,
                                      'Error', 'Poll is closed already');
                                  return;
                                }

                                if (value.answerType ==
                                    AmityPollAnswerType.SINGLE) {
                                  AmitySocialClient.newPollRepository().vote(
                                    pollId: value.pollId!,
                                    answerIds: [value.answers![index].id!],
                                  ).then((value) {
                                    CommonSnackbar.showPositiveSnackbar(context,
                                        'Success', 'Vote process successfully');
                                  }).onError((error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context, 'Error', error.toString());
                                  });
                                } else {
                                  setState(() {});
                                  if (answerIds
                                      .contains(value.answers![index].id!)) {
                                    answerIds.remove(value.answers![index].id!);
                                  } else {
                                    answerIds.add(value.answers![index].id!);
                                  }
                                }
                              },
                              child: VoteCountWidget(
                                title: value.answers![index].data ?? '',
                                votePrecentile:
                                    value.answers![index].voteCount! /
                                        value.totalVote,
                                voteCount: value.answers![index].voteCount ?? 0,
                                isMyVote: value.answers![index].isVotedByUser ??
                                    false,
                                showResult:
                                    (value.isVoted ?? false) || value.isClose,
                                isSelected: (value.answerType ==
                                        AmityPollAnswerType.MULTIPLE) &&
                                    answerIds
                                        .contains(value.answers![index].id),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                            '${snapshot.data!.totalVote} Votes \u2022  ${snapshot.data!.isClose ? 'Poll Closed' : '${snapshot.data!.closedAt!.difference(DateTime.now().toUtc()).readableString()} left'}'),
                        const Spacer(),
                        if (value.answerType == AmityPollAnswerType.MULTIPLE &&
                            !(value.isVoted ?? false))
                          SizedBox(
                              height: 24,
                              child: LoadingButton(
                                  onPressed: () async {
                                    if (answerIds.isNotEmpty) {
                                      await AmitySocialClient
                                              .newPollRepository()
                                          .vote(
                                        pollId: value.pollId!,
                                        answerIds: answerIds,
                                      )
                                          .then((value) {
                                        CommonSnackbar.showPositiveSnackbar(
                                            context,
                                            'Success',
                                            'Vote process successfully');
                                      }).onError((error, stackTrace) {
                                        CommonSnackbar.showNagativeSnackbar(
                                            context, 'Error', error.toString());
                                      });
                                    } else {
                                      CommonSnackbar.showNagativeSnackbar(
                                          context,
                                          'Error',
                                          'Please select Answer first');
                                    }
                                  },
                                  text: 'Vote')),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            value
                                .close()
                                .then((value) =>
                                    CommonSnackbar.showPositiveSnackbar(context,
                                        'Success', 'Poll Closed Succssfully'))
                                .onError((error, stackTrace) =>
                                    CommonSnackbar.showNagativeSnackbar(
                                        context, 'Error', error.toString()));
                          },
                          child: const Icon(Icons.timer_off_outlined),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            value
                                .delete()
                                .then((value) =>
                                    CommonSnackbar.showPositiveSnackbar(context,
                                        'Success', 'Poll Deleted Succssfully'))
                                .onError((error, stackTrace) =>
                                    CommonSnackbar.showNagativeSnackbar(
                                        context, 'Error', error.toString()));
                          },
                          child: const Icon(Icons.delete),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class VoteCountWidget extends StatefulWidget {
  const VoteCountWidget(
      {Key? key,
      required this.title,
      required this.votePrecentile,
      required this.voteCount,
      this.isMyVote = false,
      this.showResult = false,
      this.isSelected = false})
      : super(key: key);
  final String title;
  final double votePrecentile;
  final int voteCount;
  final bool isMyVote;
  final bool showResult;

  /// flag to only use in case of multiple answer type, to check if this answer is selected
  final bool isSelected;

  @override
  State<VoteCountWidget> createState() => _VoteCountWidgetState();
}

class _VoteCountWidgetState extends State<VoteCountWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: widget.showResult
          ? Container(
              width: double.maxFinite,
              height: 40,
              // padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: Colors.blue, width: isHover ? 2 : 1),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth *
                            (widget.votePrecentile.isNaN
                                ? 0
                                : widget.votePrecentile),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.isMyVote) const Icon(Icons.check),
                              Text(
                                widget.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                              Text('  ${widget.voteCount} Votes',
                                  style: Theme.of(context).textTheme.bodySmall)
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          : Container(
              width: double.maxFinite,
              height: 40,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    color: Colors.blue,
                    width: isHover || widget.isSelected ? 2.5 : 1),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Text('  ${widget.voteCount} Votes',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
    );
  }
}
