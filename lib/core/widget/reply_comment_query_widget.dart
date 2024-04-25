import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/reply_comment_widget.dart';

class ReplyCommentQueryWidget extends StatefulWidget {
  final String commentId;
  final String? communityId;
  final bool? isPublic;
  final String referenceType;
  final String referenceId;

  const ReplyCommentQueryWidget({
    Key? key,
    required this.referenceType,
    required this.referenceId,
    required this.commentId,
    required this.communityId,
    this.isPublic = false,
  }) : super(key: key);
  @override
  State<ReplyCommentQueryWidget> createState() =>
      _ReplyCommentQueryWidgetState();
}

class _ReplyCommentQueryWidgetState extends State<ReplyCommentQueryWidget> {
  List<AmityComment> replies = <AmityComment>[];
  late CommentLiveCollection commentLiveCollection;
  final scrollcontroller = ScrollController();

  @override
  void initState() {
    if (widget.referenceType == "post") {
      commentLiveCollection = AmitySocialClient.newCommentRepository()
          .getComments()
          .post(widget.referenceId)
          .parentId(widget.commentId)
          .sortBy(AmityCommentSortOption.LAST_CREATED)
          .includeDeleted(false)
          .getLiveCollection();
    }
    if (widget.referenceType == "story") {
      commentLiveCollection = AmitySocialClient.newCommentRepository()
          .getComments()
          .story(widget.referenceId)
          .parentId(widget.commentId)
          .sortBy(AmityCommentSortOption.LAST_CREATED)
          .includeDeleted(false)
          .getLiveCollection();
    }

    commentLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          replies = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      commentLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        commentLiveCollection.hasNextPage()) {
      setState(() {
        commentLiveCollection.loadNext();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollcontroller,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shrinkWrap: true,
      itemCount: replies.length,
      itemBuilder: (context, index) {
        final item = replies[index];
        return ReplyCommentWidget(
          comment: item,
          communityId: widget.communityId,
          isPublic: widget.isPublic,
        );
      },
    );
  }
}
