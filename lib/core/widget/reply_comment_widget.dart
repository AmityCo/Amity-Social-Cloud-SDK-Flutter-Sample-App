import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/reply_comment_query_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_comment/update_comment_screen.dart';
import 'package:go_router/go_router.dart';

class ReplyCommentWidget extends StatelessWidget {

  final AmityComment comment;
  final String? communityId;
  final bool? isPublic;

  const ReplyCommentWidget({
    Key? key,
    required this.comment,
    required this.communityId,
    this.isPublic = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    AmityUser user = comment.user!;
    bool isLikedByMe = comment.myReactions?.isNotEmpty ?? false;
    AmityCommentData data = comment.data!;
    String? text;
      if (data is CommentTextData) text = data.text!;
    return StreamBuilder<AmityComment>(
            stream: comment.listen.stream,
            initialData: comment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final value = snapshot.data!;
                AmityUser user = value.user!;
                bool isLikedByMe = value.myReactions?.isNotEmpty ?? false;
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
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(.3)),
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
                                          style: themeData.textTheme.bodyLarge!
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const WidgetSpan(
                                            child: SizedBox(width: 6)),
                                        TextSpan(
                                          text: text ?? '',
                                          style: themeData.textTheme.bodyMedium!
                                              .copyWith(),
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
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                margin: const EdgeInsets.only(
                                                    right: 6),
                                                child: SizedBox(
                                                  width: 56,
                                                  height: 56,
                                                  child: Image.network(
                                                    (value.attachments![index]
                                                            as CommentImageAttachment)
                                                        .getImage()!
                                                        .fileUrl!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  (value.target != null)
                                      ? Column(
                                          children: [
                                            (value.target
                                                    is CommunityCommentTarget)

                                                ? Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Roles:",
                                                          style: themeData
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: ((value.target
                                                                          as CommunityCommentTarget)
                                                                      .creatorMember !=
                                                                  null)
                                                              ? Text(
                                                                  (value.target
                                                                          as CommunityCommentTarget)
                                                                      .creatorMember!
                                                                      .roles
                                                                      .toString(),
                                                                  style: themeData
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(),
                                                                )
                                                              : Text(
                                                                  "[]",
                                                                  style: themeData
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(),
                                                                ),
                                                        ),
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
                                        style: themeData.textTheme.bodySmall!
                                            .copyWith(),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          if (isLikedByMe) {
                                            value
                                                .react()
                                                .removeReaction('like');
                                          } else {
                                            value.react().addReaction('like');
                                          }
                                        },
                                        onLongPress: () {
                                          GoRouter.of(context).pushNamed(
                                              AppRoute.commentReaction,
                                              params: {
                                                'commentId': value.commentId!
                                              });
                                        },
                                        child: Text(
                                          '${value.reactionCount} Likes',
                                          style: themeData.textTheme.bodySmall!
                                              .copyWith(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          if (value.isFlaggedByMe) {
                                            value
                                                .report()
                                                .unflag()
                                                .then((value) => CommonSnackbar
                                                    .showPositiveSnackbar(
                                                        context,
                                                        'Success',
                                                        'UnFlag the Comment'))
                                                .onError((error, stackTrace) =>
                                                    CommonSnackbar
                                                        .showNagativeSnackbar(
                                                            context,
                                                            'Error',
                                                            error.toString()));
                                          } else {
                                            value
                                                .report()
                                                .flag()
                                                .then((value) => CommonSnackbar
                                                    .showPositiveSnackbar(
                                                        context,
                                                        'Success',
                                                        'Flag the Comment'))
                                                .onError((error, stackTrace) =>
                                                    CommonSnackbar
                                                        .showNagativeSnackbar(
                                                            context,
                                                            'Error',
                                                            error.toString()));
                                          }
                                        },
                                        child: Text(
                                          '${value.flagCount} Flag',
                                          style: themeData.textTheme.bodySmall!
                                              .copyWith(
                                                  fontWeight:
                                                      value.isFlaggedByMe
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
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
                                  if (user.userId ==
                                      AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text("Edit"),
                                    ),
                                  if (user.userId ==
                                      AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text("Delete (Soft)"),
                                    ),
                                  if (user.userId ==
                                      AmityCoreClient.getUserId())
                                    const PopupMenuItem(
                                      value: 3,
                                      enabled: true,
                                      child: Text("Delete (Hard)"),
                                    ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: Text(value.isFlaggedByMe
                                        ? 'Unflagged'
                                        : 'Flag'),
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
                                        communityId: communityId,
                                        isPublic: isPublic ?? false,
                                      ),
                                    ),
                                  );
                                  // EditCommentDialog.show(context, amityComment: value);
                                }
                                if (index1 == 2) {
                                  value.delete();
                                }

                                if (index1 == 3) {
                                  value.delete(hardDelete: true);
                                }
                                if (index1 == 4) {
                                  if (value.isFlaggedByMe) {
                                    value
                                        .report()
                                        .unflag()
                                        .then((value) =>
                                            CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'UnFlag the Comment'))
                                        .onError((error, stackTrace) =>
                                            CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString()));
                                  } else {
                                    value
                                        .report()
                                        .flag()
                                        .then((value) =>
                                            CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'Flag the Comment'))
                                        .onError((error, stackTrace) =>
                                            CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString()));
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
  }
}