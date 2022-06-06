import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:go_router/go_router.dart';

class CommentQueryScreen extends StatefulWidget {
  const CommentQueryScreen(this._postId, {Key? key}) : super(key: key);
  final String _postId;
  @override
  State<CommentQueryScreen> createState() => _CommentQueryScreenState();
}

class _CommentQueryScreenState extends State<CommentQueryScreen> {
  late PagingController<AmityComment> _controller;
  final amityComments = <AmityComment>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityComment? _replyToComment;

  AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(widget._postId)
          .sortBy(_sortOption)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityComments.clear();
              amityComments.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
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
    print('Location - ' + GoRouter.of(context).location);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Feed'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(AmityCommentSortOption.LAST_CREATED.apiKey),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text(AmityCommentSortOption.FIRST_CREATED.apiKey),
                  value: 2,
                ),
              ];
            },
            child: const Icon(
              Icons.sort_rounded,
              size: 24,
            ),
            onSelected: (index1) {
              if (index1 == 1) {
                _sortOption = AmityCommentSortOption.LAST_CREATED;
                _controller.reset();
                _controller.fetchNextPage();
              }
              if (index1 == 2) {
                _sortOption = AmityCommentSortOption.FIRST_CREATED;
                _controller.reset();
                _controller.fetchNextPage();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: amityComments.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: amityComments.length,
                      itemBuilder: (context, index) {
                        final amityComment = amityComments[index];
                        return CommentWidget(amityComment, (value) {
                          setState(() {
                            _replyToComment = value;
                          });
                        });
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
          if (_controller.isFetching && amityComments.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          if (_replyToComment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Row(
                children: [
                  const Text('Reply to '),
                  Text('@${_replyToComment!.user!.userId}'),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _replyToComment = null;
                      });
                    },
                    icon: const Icon(
                      Icons.clear_rounded,
                    ),
                  )
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.all(12),
            child: AddCommentWidget(
              AmityCoreClient.getCurrentUser(),
              (text) async {
                if (_replyToComment != null) {
                  ///Add comment to [_replyToComment] comment
                  final _comment = await _replyToComment!
                      .comment()
                      .create()
                      .text(text)
                      .send();

                  setState(() {
                    _replyToComment = null;
                  });

                  return;
                }

                final _comment = await AmitySocialClient.newCommentRepository()
                    .createComment()
                    .post(widget._postId)
                    .create()
                    .text(text)
                    .send();
                _controller.addAtIndex(0, _comment);
                return;
              },
            ),
          ),
        ],
      ),
    );
  }
}
