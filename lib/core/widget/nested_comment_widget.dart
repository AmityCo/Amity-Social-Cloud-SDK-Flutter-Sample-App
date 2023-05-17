import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_comment/update_comment_screen.dart';
import 'package:go_router/go_router.dart';

class NestedCommentWidget extends StatefulWidget {
  const NestedCommentWidget(
      {Key? key, required this.postId, required this.commentId, required this.communityId, this.isPublic = false})
      : super(key: key);
  final String postId;
  final String commentId;

  final String? communityId;
  final bool? isPublic;

  @override
  State<NestedCommentWidget> createState() => _NestedCommentWidgetState();
}

class _NestedCommentWidgetState extends State<NestedCommentWidget> {
  late PagingController<AmityComment> _controller;
  final nestedCommentList = <AmityComment>[];

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(widget.postId)
          .parentId(widget.commentId)
          .sortBy(AmityCommentSortOption.LAST_CREATED)
          .getPagingData(token: token, limit: 5),
      pageSize: 5,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              nestedCommentList.clear();
              nestedCommentList.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context, title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        nestedCommentList.length,
        (index) {
          final amityComment = nestedCommentList[index];
          return StreamBuilder<AmityComment>(
            stream: amityComment.listen.stream,
            initialData: amityComment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final value = snapshot.data!;
                AmityUser _user = value.user!;
                bool _isLikedByMe = value.myReactions?.isNotEmpty ?? false;
                AmityCommentData data = value.data!;

                String? text;
                if (data is CommentTextData) text = data.text!;

                return !(value.isDeleted ?? false)
                    ? Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                              child: _user.avatarUrl != null
                                  ? Image.network(
                                      _user.avatarUrl!,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset('assets/user_placeholder.png'),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: _user.displayName!,
                                          style: _themeData.textTheme.bodyText1!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const WidgetSpan(child: SizedBox(width: 6)),
                                        TextSpan(
                                          text: text ?? '',
                                          style: _themeData.textTheme.bodyText2!.copyWith(),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if ((value.attachments ??= []).isNotEmpty)
                                    SizedBox(
                                      height: 56,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(
                                          value.attachments!.length,
                                          (index) => Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                margin: const EdgeInsets.only(right: 6),
                                                child: SizedBox(
                                                  width: 56,
                                                  height: 56,
                                                  child: Image.network(
                                                    (value.attachments![index] as CommentImageAttachment)
                                                        .getImage()!
                                                        .fileUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        value.createdAt!.beforeTime(),
                                        style: _themeData.textTheme.caption!.copyWith(),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          if (_isLikedByMe) {
                                            value.react().removeReaction('like');
                                          } else {
                                            value.react().addReaction('like');
                                          }
                                        },
                                        onLongPress: () {
                                          GoRouter.of(context).pushNamed(AppRoute.commentReaction,
                                              params: {'commentId': value.commentId!});
                                        },
                                        child: Text(
                                          '${value.reactionCount} Likes',
                                          style: _themeData.textTheme.caption!.copyWith(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          if (value.isFlaggedByMe) {
                                            value
                                                .report()
                                                .unflag()
                                                .then((value) => CommonSnackbar.showPositiveSnackbar(
                                                    context, 'Success', 'UnFlag the Comment'))
                                                .onError((error, stackTrace) => CommonSnackbar.showNagativeSnackbar(
                                                    context, 'Error', error.toString()));
                                          } else {
                                            value
                                                .report()
                                                .flag()
                                                .then((value) => CommonSnackbar.showPositiveSnackbar(
                                                    context, 'Success', 'Flag the Comment'))
                                                .onError((error, stackTrace) => CommonSnackbar.showNagativeSnackbar(
                                                    context, 'Error', error.toString()));
                                          }
                                        },
                                        child: Text(
                                          '${value.flagCount} Flag',
                                          style: _themeData.textTheme.caption!.copyWith(
                                              fontWeight: value.isFlaggedByMe ? FontWeight.bold : FontWeight.normal),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  if (_user.userId == AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      child: Text("Edit"),
                                      value: 1,
                                    ),
                                  if (_user.userId == AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      child: Text("Delete (Soft)"),
                                      value: 2,
                                    ),
                                  if (_user.userId == AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      child: Text("Delete (Hard)"),
                                      value: 3,
                                      enabled: false,
                                    ),
                                  PopupMenuItem(
                                    child: Text(value.isFlaggedByMe ? 'Unflagged' : 'Flag'),
                                    value: 4,
                                  ),
                                ];
                              },
                              child: const Icon(
                                Icons.more_vert_rounded,
                                size: 18,
                              ),
                              onSelected: (index1) {
                                if (index1 == 1) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UpdateCommentScreen(
                                        amityComment: value,
                                        communityId: widget.communityId,
                                        isPublic: widget.isPublic ?? false,
                                      ),
                                    ),
                                  );
                                  // EditCommentDialog.show(context, amityComment: value);
                                }
                                if (index1 == 2) {
                                  value.delete();
                                }
                                if (index1 == 4) {
                                  if (value.isFlaggedByMe) {
                                    value
                                        .report()
                                        .unflag()
                                        .then((value) => CommonSnackbar.showPositiveSnackbar(
                                            context, 'Success', 'UnFlag the Comment'))
                                        .onError((error, stackTrace) =>
                                            CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString()));
                                  } else {
                                    value
                                        .report()
                                        .flag()
                                        .then((value) =>
                                            CommonSnackbar.showPositiveSnackbar(context, 'Success', 'Flag the Comment'))
                                        .onError((error, stackTrace) =>
                                            CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString()));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : Container();
              }
              return Container();
            },
          );
        },
      )..add(
          _controller.hasMoreItems
              ? Container(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: InkWell(
                    onTap: () {
                      _controller.fetchNextPage();
                    },
                    child: Text(
                      'Load more',
                      style: _themeData.textTheme.caption!.copyWith(),
                    ),
                  ),
                )
              : Container(),
        ),
    );
  }
}
