import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class CommentQueryReplyScreen extends StatefulWidget {
  const CommentQueryReplyScreen(this._postId, this._parentCommentId,
      {Key? key, this.communityId, this.isPublic = false})
      : super(key: key);
  final String? communityId;
  final bool isPublic;
  final String _postId;
  final String _parentCommentId;
  @override
  State<CommentQueryReplyScreen> createState() => _CommentQueryReplyScreenState();
}

class _CommentQueryReplyScreenState extends State<CommentQueryReplyScreen> {
  late PagingController<AmityComment> _controller;
  final amityComments = <AmityComment>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  AmityCommentDataTypeFilter? dataTypes;

  bool _includeDeleted = false;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(widget._postId)
          .parentId(widget._parentCommentId)
          .sortBy(_sortOption)
          .dataTypes(dataTypes)
          .includeDeleted(_includeDeleted)
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
            ErrorDialog.show(context, title: 'Error', message: _controller.error.toString());
            print(_controller.stacktrace);
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
    if ((scrollcontroller.position.pixels == scrollcontroller.position.maxScrollExtent) && _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Feed'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Text(AmityCommentSortOption.LAST_CREATED.apiKey),
                ),
                PopupMenuItem(
                  value: 8,
                  child: Text(AmityCommentSortOption.LAST_UPDATED.apiKey),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(AmityCommentSortOption.FIRST_CREATED.apiKey),
                ),
                PopupMenuItem(
                  value: 9,
                  child: Text(AmityCommentSortOption.FIRST_UPDATED.apiKey),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text('Excat TEXT'),
                ),
                const PopupMenuItem(
                  value: 4,
                  child: Text('Excat IMAGE'),
                ),
                const PopupMenuItem(
                  value: 11,
                  child: Text('Excat IMAGE & TEXT'),
                ),
                const PopupMenuItem(
                  value: 5,
                  child: Text('Any TEXT'),
                ),
                const PopupMenuItem(
                  value: 6,
                  child: Text('Any IMAGE'),
                ),
                const PopupMenuItem(
                  value: 12,
                  child: Text('Any IMAGE & TEXT'),
                ),
                const PopupMenuItem(
                  value: 7,
                  child: Text('Clear'),
                ),
                const PopupMenuItem(
                  value: 10,
                  child: Text('Include Deleted'),
                ),
                const PopupMenuItem(
                  value: 13,
                  child: Text('Exclude Deleted'),
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
              }
              if (index1 == 2) {
                _sortOption = AmityCommentSortOption.FIRST_CREATED;
              }
              if (index1 == 8) {
                _sortOption = AmityCommentSortOption.LAST_UPDATED;
              }
              if (index1 == 9) {
                _sortOption = AmityCommentSortOption.FIRST_UPDATED;
              }

              if (index1 == 3) {
                dataTypes = AmityCommentDataTypeFilter.exact(dataTypes: [AmityDataType.TEXT]);
              }

              if (index1 == 4) {
                dataTypes = AmityCommentDataTypeFilter.exact(dataTypes: [AmityDataType.IMAGE]);
              }
              if (index1 == 11) {
                dataTypes = AmityCommentDataTypeFilter.exact(dataTypes: [AmityDataType.TEXT, AmityDataType.IMAGE]);
              }

              if (index1 == 5) {
                dataTypes = AmityCommentDataTypeFilter.any(dataTypes: [AmityDataType.TEXT]);
              }

              if (index1 == 6) {
                dataTypes = AmityCommentDataTypeFilter.any(dataTypes: [AmityDataType.IMAGE]);
              }

              if (index1 == 12) {
                dataTypes = AmityCommentDataTypeFilter.any(dataTypes: [AmityDataType.IMAGE, AmityDataType.TEXT]);
              }

              if (index1 == 7) {
                dataTypes = null;
              }

              if (index1 == 10) {
                _includeDeleted = true;
              }

              if (index1 == 13) {
                _includeDeleted = false;
              }

              setState(() {});
              _controller.reset();
              _controller.fetchNextPage();
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
                        return CommentWidget(
                          widget._postId,
                          amityComment,
                          (value) {
                            // setState(() {
                            //   _replyToComment = value;
                            // });
                          },
                          key: UniqueKey(),
                          communityId: widget.communityId,
                          isPublic: widget.isPublic,
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching ? const CircularProgressIndicator() : const Text('No Comment'),
                  ),
          ),
          if (_controller.isFetching && amityComments.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<AmityImage> waitForUploadComplete(Stream<AmityUploadResult> source) {
    final completer = Completer<AmityImage>();
    source.listen((event) {
      event.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) => completer.complete(file),
        error: (error) => completer.completeError(error),
        cancel: () {},
      );
    });
    return completer.future;
  }
}
