import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dynamic_text_highlighting.dart';
import 'package:flutter_social_sample_app/core/widget/reply_comment_query_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_comment/update_comment_screen.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(
    this.referenceType,
    this.referenceId,
    this.amityComment,
    this.onReply, {
    Key? key,
    required this.communityId,
    required this.isPublic,
    this.disableAction = false,
  }) : super(key: key);
  final String referenceType;
  final String referenceId;
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

  @override
  void initState() {
    super.initState();
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_rounded),
                      const SizedBox(width: 12),
                      Text(
                        'Comment has been deleted',
                        style: themeData.textTheme.bodySmall,
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
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
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
                          highlights: value.mentionees
                                  ?.map<String>(
                                      (e) => '@${e.user?.displayName ?? ''}')
                                  .toList() ??
                              [],
                          onHighlightClick: (String displayName) {
                            final amityUser = value.mentionees!
                                .firstWhereOrNull((element) =>
                                    element.user!.displayName ==
                                    displayName.replaceAll('@', ''));
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
                (value.target != null)
                    ? Column(
                        children: [
                          (value.target is CommunityCommentTarget)
                              ? Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Roles:",
                                        style: themeData.textTheme.bodySmall!
                                            .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ((value.target as CommunityCommentTarget)
                                                  .creatorMember !=
                                              null)
                                          ? Text(
                                              (value.target
                                                      as CommunityCommentTarget)
                                                  .creatorMember!
                                                  .roles
                                                  .toString(),
                                              style: themeData
                                                  .textTheme.bodySmall!
                                                  .copyWith(),
                                            )
                                          : Text(
                                              "[]",
                                              style: themeData
                                                  .textTheme.bodySmall!
                                                  .copyWith(),
                                            )
                                    ],
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 6),
                        ],
                      )
                    : Container(),

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
                        GoRouter.of(context).pushNamed(AppRoute.commentReaction,
                            params: {'commentId': value.commentId!});
                      },
                      child: Text(
                        '${value.reactionCount} Likes',
                        style: themeData.textTheme.bodySmall!.copyWith(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        widget.onReply(value);
                      },
                      child: Text(
                        'Reply',
                        style: themeData.textTheme.bodySmall!.copyWith(),
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
                                  CommonSnackbar.showPositiveSnackbar(
                                      context, 'Success', 'UnFlag the Comment'))
                              .onError((error, stackTrace) =>
                                  CommonSnackbar.showNagativeSnackbar(
                                      context, 'Error', error.toString()));
                        } else {
                          value
                              .report()
                              .flag()
                              .then((value) =>
                                  CommonSnackbar.showPositiveSnackbar(
                                      context, 'Success', 'Flag the Comment'))
                              .onError((error, stackTrace) =>
                                  CommonSnackbar.showNagativeSnackbar(
                                      context, 'Error', error.toString()));
                        }
                      },
                      child: Text(
                        '${value.flagCount} Flag',
                        style: themeData.textTheme.bodySmall!.copyWith(
                            fontWeight: value.isFlaggedByMe
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  'Comment ID - ${value.commentId}',
                  style: themeData.textTheme.bodySmall,
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: const EdgeInsets.only(right: 6),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: ((value.attachments![index]
                                                as CommentImageAttachment)
                                            .getImage()
                                            ?.fileUrl !=
                                        null)
                                    ? Image.network(
                                        (value.attachments![index]
                                                as CommentImageAttachment)
                                            .getImage()!
                                            .fileUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(width: 56, height: 56),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Text('Attachments - ${(value.attachments ??= []).isNotEmpty}'),
                Text(value.dataTypes.toString()),
                const SizedBox(height: 6),
                if (value.childrenNumber! > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      child: ReplyCommentQueryWidget(
                                        referenceId: widget.referenceId,
                                        referenceType: widget.referenceType,
                                        commentId: value.commentId!,
                                        communityId: widget.communityId,
                                        isPublic: widget.isPublic,
                                      ),
                                    );
                                }
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: Text(
                                '~~~~~~ View ${value.childrenNumber} more reply',
                                style:
                                    themeData.textTheme.bodySmall!.copyWith(),
                              ),
                            ),
                          )

                        // : _getChildCommentWidget(context, value.latestReplies!),
                        
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
                  const PopupMenuItem(
                    value: 6,
                    child: Text("Reply Comment List"),
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
                        .then((value) => CommonSnackbar.showPositiveSnackbar(
                            context, 'Success', 'UnFlag the Comment'))
                        .onError((error, stackTrace) =>
                            CommonSnackbar.showNagativeSnackbar(
                                context, 'Error', error.toString()));
                  } else {
                    value
                        .report()
                        .flag()
                        .then((value) => CommonSnackbar.showPositiveSnackbar(
                            context, 'Success', 'Flag the Comment'))
                        .onError((error, stackTrace) =>
                            CommonSnackbar.showNagativeSnackbar(
                                context, 'Error', error.toString()));
                  }
                }
                if (index1 == 5) {
                  GoRouter.of(context)
                      .pushNamed(AppRoute.commentRTE, queryParams: {
                    'commentId': value.commentId,
                    'referenceType': widget.referenceType,
                    'referenceId': widget.referenceId,
                    'communityId': widget.communityId,
                    'isPublic': widget.isPublic.toString()
                  });
                }
                if (index1 == 6) {
                  GoRouter.of(context).pushNamed(
                    AppRoute.commentListReply,
                    queryParams: {
                      'referenceType': widget.referenceType,
                      'referenceId': widget.referenceId,
                      'parentId': value.commentId,
                      'communityId': widget.communityId,
                      'isPublic': widget.isPublic.toString()
                    },
                  );
                  // GoRouter.of(context).pushNamed(AppRoute.commentRTE, queryParams: {
                  //   'commentId': value.commentId,
                  //   'postId': widget.postId,
                  //   'communityId': widget.communityId,
                  //   'isPublic': widget.isPublic.toString()
                  // });
                }
              },
            ),
        ],
      ),
    );
  }
}
