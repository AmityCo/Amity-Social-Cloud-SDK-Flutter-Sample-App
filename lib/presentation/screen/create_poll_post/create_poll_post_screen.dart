import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/loading_button.dart';

class CreatePollPostScreen extends StatefulWidget {
  const CreatePollPostScreen({Key? key, this.userId, this.communityId})
      : super(key: key);
  final String? userId;
  final String? communityId;
  @override
  State<CreatePollPostScreen> createState() => _CreatePollPostScreenState();
}

class _CreatePollPostScreenState extends State<CreatePollPostScreen> {
  final _targetuserTextEditController = TextEditingController();
  final _pollQuestionTextController = TextEditingController();
  final _pollScheduleTextController = TextEditingController(text: '1');
  bool _multiSelection = false;
  List<String> _option = [];
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final isCommunityPost = widget.communityId != null;
    var targetLabel = '';
    if (isCommunityPost) {
      targetLabel = 'Target community';
      _targetuserTextEditController.text = widget.communityId!;
    } else {
      targetLabel = 'Target user';
      if (widget.userId != null) {
        _targetuserTextEditController.text = widget.userId!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll Post'),
        actions: [
          LoadingButton(
              onPressed: () async {
                try {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final target = _targetuserTextEditController.text.trim();
                  String question = _pollQuestionTextController.text.trim();
                  int closeInMins =
                      int.tryParse(_pollScheduleTextController.text.trim()) ??
                          60;

                  if (closeInMins > 43200) {
                    CommonSnackbar.showNagativeSnackbar(context, 'Error',
                        'Close days can\'t be more then 30 days (30*1440 min)');
                    return;
                  }
                  if (_option.length < 2) {
                    CommonSnackbar.showNagativeSnackbar(
                        context, 'Error', 'Please add more then 2 option');
                    return;
                  }
                  // *
                  // 86400000;

                  final amityPoll = await AmitySocialClient.newPollRepository()
                      .createPoll(question: question)
                      .answers(
                          answers: _option
                              .map((e) => AmityPollAnswer.text(e))
                              .toList())
                      .answerType(
                          answerType: _multiSelection
                              ? AmityPollAnswerType.MULTIPLE
                              : AmityPollAnswerType.SINGLE)
                      .closedIn(
                          closedIn: Duration(milliseconds: closeInMins * 60000))
                      .create();
                  if (isCommunityPost) {
                    final amityPost =
                        await AmitySocialClient.newPostRepository()
                            .createPost()
                            .targetCommunity(target)
                            .poll(amityPoll.pollId!)
                            .text(amityPoll.question!)
                            .post();
                  } else {
                    final amityPost =
                        await AmitySocialClient.newPostRepository()
                            .createPost()
                            .targetUser(target)
                            .poll(amityPoll.pollId!)
                            .text(amityPoll.question!)
                            .post();
                  }

                  CommonSnackbar.showPositiveSnackbar(
                      context, 'Success', 'Poll Post Created Successfully');
                } catch (error, stackTrace) {
                  print(stackTrace.toString());
                  CommonSnackbar.showNagativeSnackbar(
                      context, 'Error', error.toString());
                }
              },
              text: 'POST'),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _targetuserTextEditController,
                enabled: !isCommunityPost,
                decoration: InputDecoration(
                  label: Text(targetLabel),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Poll Question',
                style: themeData.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _pollQuestionTextController,
                maxLength: 5000,
                decoration: const InputDecoration(
                  hintText: 'Question',
                ),
              ),
              const SizedBox(height: 12),
              AddAnswerWidget(
                valueChanged: (value) {
                  _option = value;
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Multiple Selection'),
                subtitle: const Text('Allow user to select multiple option'),
                value: _multiSelection,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _multiSelection = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Schedule Poll (Option)',
                style: themeData.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Poll will close after the end of chosen time frame in min. You can setup upto 30 days (max 30 * 1440 min) (by default 60 min)',
                style: themeData.textTheme.bodySmall!.copyWith(),
              ),
              TextFormField(
                controller: _pollScheduleTextController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Mins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddAnswerWidget extends StatefulWidget {
  const AddAnswerWidget({Key? key, required this.valueChanged})
      : super(key: key);
  final ValueChanged<List<String>> valueChanged;
  @override
  State<AddAnswerWidget> createState() => _AddAnswerWidgetState();
}

class _AddAnswerWidgetState extends State<AddAnswerWidget> {
  final List<String> _option = [];
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Options',
            style: themeData.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Create at least two option',
            style: themeData.textTheme.bodySmall!.copyWith(),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            _option.length,
            (index) {
              String s = _option[index];
              return Container(
                margin: const EdgeInsets.all(2),
                child: ListTile(
                  title: Text(s),
                  tileColor: Colors.grey.withOpacity(.2),
                  minVerticalPadding: 2,
                  dense: false,
                  trailing: IconButton(
                    onPressed: () {
                      _option.remove(s);
                      widget.valueChanged(_option);
                      setState(() {});
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                  onTap: () {
                    EditTextDialog.show(context,
                        title: 'Option',
                        hintText: 'Enter Option here',
                        defString: s,
                        buttonText: 'OK', onPress: (value) {
                      setState(() {
                        if (_option.contains(s)) {
                          _option.remove(s);
                          _option.add(value);
                        }
                        widget.valueChanged(_option);
                      });
                    });
                  },
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: double.maxFinite,
            child: OutlinedButton.icon(
              onPressed: () {
                EditTextDialog.show(context,
                    title: 'Option',
                    hintText: 'Enter Option here',
                    buttonText: 'OK', onPress: (value) {
                  setState(() {
                    if (!_option.contains(value)) _option.add(value);
                    widget.valueChanged(_option);
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
              style: TextButton.styleFrom(),
            ),
          )
        ],
      ),
    );
  }
}
