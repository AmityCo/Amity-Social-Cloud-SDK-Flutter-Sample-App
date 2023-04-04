import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/text_check_box_widget.dart';
import 'package:go_router/go_router.dart';

class CommentRteEventScreen extends StatefulWidget {
  const CommentRteEventScreen(
      {super.key, required this.postId, required this.commentId, this.communityId, this.isPublic = false});
  final String postId;
  final String? communityId;
  final bool isPublic;
  final String commentId;
  @override
  State<CommentRteEventScreen> createState() => _CommentRteEventScreenState();
}

class _CommentRteEventScreenState extends State<CommentRteEventScreen> {
  AmityComment? _comment;

  final eventPool = <String, bool>{};

  late Future<AmityComment> _amityCommentFuture;
  @override
  void initState() {
    _amityCommentFuture = AmitySocialClient.newCommentRepository().getComment(commentId: widget.commentId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Unsubscribe to all comment events
        for (var event in AmityCommentEvents.values) {
          _comment!.subscription(event).unsubscribeTopic();
        }

        GoRouter.of(context).pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subscribe Comment'),
        ),
        body: Container(
          child: FutureBuilder(
            future: _amityCommentFuture,
            initialData: _comment,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _comment = snapshot.data as AmityComment;
                _comment!;
                return Container(
                  child: Column(
                    children: [
                      ShadowContainerWidget(
                        child: Row(
                          children: [
                            ...List.generate(
                              AmityCommentEvents.values.length,
                              (index) => TextCheckBox(
                                title: AmityCommentEvents.values[index].name,
                                value: eventPool[AmityCommentEvents.values[index].name] ?? false,
                                onChanged: (value) {
                                  eventPool[AmityCommentEvents.values[index].name] = value ?? false;

                                  if (eventPool[AmityCommentEvents.values[index].name] ?? false) {
                                    ///Subscribe to the event
                                    _comment!.subscription(AmityCommentEvents.values[index]).subscribeTopic();
                                  } else {
                                    ///Unsubscribe to the event
                                    _comment!.subscription(AmityCommentEvents.values[index]).unsubscribeTopic();
                                  }
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      CommentWidget(
                        widget.postId,
                        _comment!,
                        (value) {},
                        communityId: widget.communityId,
                        isPublic: widget.isPublic,
                        disableAction: true,
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error - ${snapshot.error.toString()}'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
