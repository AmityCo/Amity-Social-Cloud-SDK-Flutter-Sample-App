import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dynamic_text_highlighting.dart';
import 'package:flutter_social_sample_app/core/widget/nested_comment_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_comment/update_comment_screen.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(
    this.postId,
    this.amityComment,
    this.onReply, {
    Key? key,
    required this.communityId,
    required this.isPublic,
    this.disableAction = false,
  }) : super(key: key);
  final String postId;
  final String? communityId;
  final bool? isPublic;
  final AmityComment amityComment;
  final ValueChanged<AmityComment> onReply;
  final bool disableAction;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late String text;

  bool _viewMoreReply = false;
  late Timer periodicTimer;
  @override
  void initState() {
    super.initState();

    // widget.amityComment
    //     .subscription(AmityCommentEvents.COMMENT)
    //     .subscribeTopic()
    //     .then((value) {
    //   print('Post RTE subscription success');
    // });

    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return StreamBuilder<AmityComment>(
      stream: widget.amityComment.listen.stream,
      initialData: widget.amityComment,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return !(snapshot.data!.isDeleted ?? false)
              ? _getBody(context, snapshot.data!)
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_rounded),
                      const SizedBox(width: 12),
                      Text(
                        'Comment has been deleted',
                        style: themeData.textTheme.caption,
                      )
                    ],
                  ),
                );
        }
        return Container();
      },
    );
  }

  Widget _getBody(BuildContext context, AmityComment value) {
    final themeData = Theme.of(context);
    AmityUser user = value.user!;

    bool isLikedByMe = value.myReactions?.isNotEmpty ?? false;

    AmityCommentData data = value.data!;
    if (data is CommentTextData) text = data.text!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: user.avatarUrl != null
                ? Image.network(
                    user.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
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
                        text: user.displayName!,
                        style: themeData.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      WidgetSpan(
                        child: DynamicTextHighlighting(
                          text: text,
                          highlights:
                              value.mentionees?.map<String>((e) => '@${e.user?.displayName ?? ''}').toList() ?? [],
                          onHighlightClick: (String displayName) {
                            final amityUser = value.mentionees!.firstWhereOrNull(
                                (element) => element.user!.displayName == displayName.replaceAll('@', ''));
                            if (amityUser != null) {
                              GoRouter.of(context).pushNamed(
                                AppRoute.profile,
                                params: {
                                  'userId': amityUser.userId,
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      value.createdAt!.beforeTime(),
                      style: themeData.textTheme.bodySmall!.copyWith(),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        if (isLikedByMe) {
                          value.react().removeReaction('like');
                        } else {
                          value.react().addReaction('like');
                        }
                      },
                      onLongPress: () {
                        GoRouter.of(context)
                            .pushNamed(AppRoute.commentReaction, params: {'commentId': value.commentId!});
                      },
                      child: Text(
                        '${value.reactionCount} Likes',
                        style: themeData.textTheme.caption!.copyWith(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        widget.onReply(value);
                      },
                      child: Text(
                        'Reply',
                        style: themeData.textTheme.caption!.copyWith(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        if (value.isFlaggedByMe) {
                          value
                              .report()
                              .unflag()
                              .then((value) =>
                                  CommonSnackbar.showPositiveSnackbar(context, 'Success', 'UnFlag the Comment'))
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
                      },
                      child: Text(
                        '${value.flagCount} Flag',
                        style: themeData.textTheme.caption!
                            .copyWith(fontWeight: value.isFlaggedByMe ? FontWeight.bold : FontWeight.normal),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  'Comment ID - ${value.commentId}',
                  style: themeData.textTheme.caption,
                ),
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
                                        (value.attachments![index] as CommentImageAttachment).getImage()!.fileUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  ),
                // Text('Attachments - ${(value.attachments ??= []).isNotEmpty}'),
                const SizedBox(height: 6),
                if (value.childrenNumber! > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: !_viewMoreReply
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _viewMoreReply = !_viewMoreReply;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: Text(
                                '~~~~~~ View ${value.childrenNumber} more reply',
                                style: themeData.textTheme.caption!.copyWith(),
                              ),
                            ),
                          )
                        // : _getChildCommentWidget(context, value.latestReplies!),
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _viewMoreReply = !_viewMoreReply;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    '~~~~~~ Hide reply',
                                    style: themeData.textTheme.caption!.copyWith(),
                                  ),
                                ),
                              ),
                              NestedCommentWidget(
                                postId: widget.postId,
                                commentId: value.commentId!,
                              ),
                            ],
                          ),
                  )
              ],
            ),
          ),
          if (!widget.disableAction)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (user.userId == AmityCoreClient.getUserId())
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Edit"),
                    ),
                  if (user.userId == AmityCoreClient.getUserId())
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Delete (Soft)"),
                    ),
                  if (user.userId == AmityCoreClient.getUserId())
                    const PopupMenuItem(
                      value: 3,
                      enabled: false,
                      child: Text("Delete (Hard)"),
                    ),
                  PopupMenuItem(
                    value: 4,
                    child: Text(value.isFlaggedByMe ? 'Unflagged' : 'Flag'),
                  ),
                  const PopupMenuItem(
                    value: 5,
                    child: Text("RTE"),
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
                }
                if (index1 == 2) {
                  value.delete();
                }
                if (index1 == 4) {
                  if (value.isFlaggedByMe) {
                    value
                        .report()
                        .unflag()
                        .then((value) => CommonSnackbar.showPositiveSnackbar(context, 'Success', 'UnFlag the Comment'))
                        .onError((error, stackTrace) =>
                            CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString()));
                  } else {
                    value
                        .report()
                        .flag()
                        .then((value) => CommonSnackbar.showPositiveSnackbar(context, 'Success', 'Flag the Comment'))
                        .onError((error, stackTrace) =>
                            CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString()));
                  }
                }
                if (index1 == 5) {
                  GoRouter.of(context).pushNamed(AppRoute.commentRTE, queryParams: {
                    'commentId': value.commentId,
                    'postId': widget.postId,
                    'communityId': widget.communityId,
                    'isPublic': widget.isPublic.toString()
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    periodicTimer.cancel();
    super.dispose();
  }
}
