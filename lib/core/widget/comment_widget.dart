import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/nested_comment_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_comment/update_comment_screen.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(this.postId, this.amityComment, this.onReply, {Key? key})
      : super(key: key);
  final String postId;
  final AmityComment amityComment;
  final ValueChanged<AmityComment> onReply;
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

    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

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
                        style: _themeData.textTheme.caption,
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
    final _themeData = Theme.of(context);
    AmityUser _user = value.user!;

    bool _isLikedByMe = value.myReactions?.isNotEmpty ?? false;

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
                        text: text,
                        style: _themeData.textTheme.bodyText2!.copyWith(),
                      )
                    ],
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
                        widget.onReply(value);
                      },
                      child: Text(
                        'Reply',
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
                        style: _themeData.textTheme.caption!.copyWith(
                            fontWeight: value.isFlaggedByMe
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    )
                  ],
                ),
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
                                style: _themeData.textTheme.caption!.copyWith(),
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
                                    style: _themeData.textTheme.caption!
                                        .copyWith(),
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

//   Widget _getChildCommentWidget(
//       BuildContext context, List<AmityComment> comments) {
//     final _themeData = Theme.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(
//         comments.length,
//         (index) {
//           final amityComment = comments[index];
//           return StreamBuilder<AmityComment>(
//             stream: amityComment.listen,
//             initialData: amityComment,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final value = snapshot.data!;
//                 AmityUser _user = value.user!;
//                 bool _isFlagedByMe = value.myReactions?.isNotEmpty ?? false;
//                 AmityCommentData data = value.data!;
//                 if (data is CommentTextData) text = data.text!;

//                 return !(value.isDeleted ?? false)
//                     ? Container(
//                         margin: const EdgeInsets.only(top: 12, bottom: 12),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.grey.withOpacity(.3)),
//                               child: _user.avatarUrl != null
//                                   ? Image.network(
//                                       _user.avatarUrl!,
//                                       fit: BoxFit.fill,
//                                     )
//                                   : Image.asset('assets/user_placeholder.png'),
//                               clipBehavior: Clip.antiAliasWithSaveLayer,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: _user.displayName!,
//                                           style: _themeData.textTheme.bodyText1!
//                                               .copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const WidgetSpan(
//                                             child: SizedBox(width: 6)),
//                                         TextSpan(
//                                           text: text,
//                                           style: _themeData.textTheme.bodyText2!
//                                               .copyWith(),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         value.createdAt!.beforeTime(),
//                                         style: _themeData.textTheme.caption!
//                                             .copyWith(),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       InkWell(
//                                         onTap: () {
//                                           if (_isFlagedByMe) {
//                                             value
//                                                 .react()
//                                                 .removeReaction('like');
//                                           } else {
//                                             value.react().addReaction('like');
//                                           }
//                                         },
//                                         child: Text(
//                                           '${value.reactionCount} Likes',
//                                           style: _themeData.textTheme.caption!
//                                               .copyWith(),
//                                         ),
//                                       ),
//                                       // InkWell(
//                                       //   onTap: () {
//                                       //     widget.onReply(value);
//                                       //   },
//                                       //   child: Text(
//                                       //     'Reply',
//                                       //     style: _themeData.textTheme.caption!.copyWith(),
//                                       //   ),
//                                       // )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (_user.userId == AmityCoreClient.getUserId())
//                               PopupMenuButton(
//                                 itemBuilder: (context) {
//                                   return const [
//                                     PopupMenuItem(
//                                       child: Text("Edit"),
//                                       value: 1,
//                                     ),
//                                     PopupMenuItem(
//                                       child: Text("Delete (Soft)"),
//                                       value: 2,
//                                     ),
//                                     PopupMenuItem(
//                                       child: Text("Delete (Hard)"),
//                                       value: 3,
//                                       enabled: false,
//                                     )
//                                   ];
//                                 },
//                                 child: const Icon(
//                                   Icons.more_vert_rounded,
//                                   size: 18,
//                                 ),
//                                 onSelected: (index1) {
//                                   if (index1 == 1) {
//                                     EditCommentDialog.show(context,
//                                         amityComment: value);
//                                   }
//                                   if (index1 == 2) {
//                                     value.delete();
//                                   }
//                                 },
//                               ),
//                           ],
//                         ),
//                       )
//                     : Container();
//               }
//               return Container();
//             },
//           );
//         },
//       )..add(Container(
//           padding: const EdgeInsets.only(left: 12, top: 8),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 _viewMoreReply = !_viewMoreReply;
//               });
//             },
//             child: Text(
//               'View less',
//               style: _themeData.textTheme.caption!.copyWith(),
//             ),
//           ),
//         )),
//     );
//   }
}
