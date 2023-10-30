import 'package:amity_sdk/amity_sdk.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dynamic_text_highlighting.dart';
import 'package:flutter_social_sample_app/core/widget/poll_widget.dart';
import 'package:flutter_social_sample_app/core/widget/reaction_action_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_post/update_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/video_player/full_screen_video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedWidget extends StatelessWidget {
  final String? communityId;
  final bool isPublic;
  final AmityPost amityPost;
  final bool disableAction;
  final bool disableAddComment;
  // final VoidCallback onCommentCallback;
  const FeedWidget(
      {Key? key,
      required this.amityPost,
      this.communityId,
      this.isPublic = false,
      this.disableAction = false,
      this.disableAddComment = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return StreamBuilder<AmityPost>(
      stream: amityPost.listen.stream,
      initialData: amityPost,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          return Stack(
            fit: StackFit.loose,
            children: [
              ShadowContainerWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileInfoRowWidget(
                      userId: value.postedUser!.userId!,
                      userAvatar: value.postedUser?.avatarUrl ??
                          value.postedUser!.avatarCustomUrl,
                      userName: value.postedUser!.displayName!,
                      options: disableAction
                          ? null
                          : [
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    if (amityPost.postedUserId ==
                                        AmityCoreClient.getUserId())
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text("Edit"),
                                      ),
                                    if (amityPost.postedUserId ==
                                        AmityCoreClient.getUserId())
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text("Delete (Soft)"),
                                      ),
                                    if (amityPost.postedUserId ==
                                        AmityCoreClient.getUserId())
                                      const PopupMenuItem(
                                        value: 3,
                                        enabled: false,
                                        child: Text("Delete (Hard)"),
                                      ),
                                    const PopupMenuItem(
                                      value: 4,
                                      child: Text("RTE"),
                                    )
                                  ];
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  size: 18,
                                ),
                                onSelected: (index) {
                                  if (index == 1) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePostScreen(
                                          amityPost: value,
                                          communityId: communityId,
                                          isPublic: isPublic,
                                        ),
                                      ),
                                    );
                                  }
                                  if (index == 2) {
                                    value.delete();
                                  }
                                  if (index == 4) {
                                    /// jumpe to Post RTE screen
                                    GoRouter.of(context).pushNamed(
                                        AppRoute.postRTE,
                                        queryParams: {
                                          'postId': value.postId!,
                                          'communityId': communityId,
                                          'isPublic': isPublic.toString()
                                        });
                                  }
                                },
                              ),
                            ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created At - ${value.createdAt!.format()}',
                            style: themeData.textTheme.bodySmall,
                          ),
                          Text(
                            'Updated At - ${value.updatedAt!.format()}',
                            style: themeData.textTheme.bodySmall,
                          ),
                          SelectableText(
                            'Post ID - ${value.postId!}',
                            style: themeData.textTheme.bodySmall,
                          ),
                          if (value.target is UserTarget)
                            Text(
                              'Posted On : ${(value.target as UserTarget).targetUser?.displayName ?? 'No name'}',
                              style: themeData.textTheme.bodySmall,
                            ),
                          if (value.target is CommunityTarget)
                            Text(
                              'Posted On : ${(value.target as CommunityTarget).targetCommunity?.displayName ?? 'No name'} Community',
                              style: themeData.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (value.data != null)
                            FeedContentWidget(
                                amityPost: value, amityPostData: value.data!),
                          const SizedBox(height: 8),
                          if (value.children != null)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ...List.generate(value.children!.length,
                                    (index) {
                                  final amityChildPost = value.children![index];
                                  if (amityChildPost.data == null) {
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Text(
                                        'Media Type ${amityChildPost.type} not supported',
                                        style: themeData.textTheme.bodyLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                    );
                                  }
                                  return FeedContentWidget(
                                      amityPost: value,
                                      amityPostData: amityChildPost.data!);
                                })
                              ],
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(height: .5, color: Colors.grey.shade300),
                    Container(
                        key: UniqueKey(),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: FeedReactionInfoWidget(amityPost: value)),
                    Divider(height: .5, color: Colors.grey.shade300),
                    FeedReactionActionWidget(
                        key: UniqueKey(),
                        amityPost: value,
                        onCommentCallback: () {
                          GoRouter.of(context).pushNamed(
                            AppRoute.commentList,
                            queryParams: {
                              'postId': value.postId!,
                              'communityId': communityId,
                              'isPublic': isPublic.toString()
                            },
                          );
                        }),
                    const SizedBox(height: 12),
                    if (!disableAddComment)
                      AddCommentWidget(
                        AmityCoreClient.getCurrentUser(),
                        (text, user, attachments) {
                          final mentionUsers = <AmityUser>[];

                          mentionUsers.clear();
                          mentionUsers.addAll(user);

                          //Clean up mention user list, as user might have removed some tagged user
                          mentionUsers.removeWhere((element) =>
                              !text.contains(element.displayName!));

                          final amityMentioneesMetadata = mentionUsers
                              .map<AmityUserMentionMetadata>((e) =>
                                  AmityUserMentionMetadata(
                                      userId: e.userId!,
                                      index: text.indexOf('@${e.displayName!}'),
                                      length: e.displayName!.length))
                              .toList();

                          Map<String, dynamic> metadata =
                              AmityMentionMetadataCreator(
                                      amityMentioneesMetadata)
                                  .create();

                          value
                              .comment()
                              .create()
                              .text(text)
                              .mentionUsers(mentionUsers
                                  .map<String>((e) => e.userId!)
                                  .toList())
                              .metadata(metadata)
                              .send();
                        },
                        communityId: communityId,
                        isPublic: isPublic,
                      ),
                  ],
                ),
              ),
              if (value.isDeleted ?? false)
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Soft Deleted Amity Post',
                          style: themeData.textTheme.bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          );
        }
        return Container();
      },
    );
  }
}

class FeedContentWidget extends StatelessWidget {
  final AmityPost amityPost;
  final AmityPostData amityPostData;
  const FeedContentWidget(
      {Key? key, required this.amityPost, required this.amityPostData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (amityPostData is TextData) {
      final data = amityPostData as TextData;
      if (data.text != null && data.text!.isNotEmpty) {
        return DynamicTextHighlighting(
          text: data.text ?? '',
          highlights: amityPost.mentionees
                  ?.map<String>((e) => '@${e.user?.displayName ?? ''}')
                  .toList() ??
              [],
          onHighlightClick: (String value) {
            final amityUser = amityPost.mentionees!.firstWhereOrNull(
                (element) =>
                    element.user!.displayName == value.replaceAll('@', ''));
            if (amityUser != null) {
              GoRouter.of(context).pushNamed(
                AppRoute.profile,
                params: {
                  'userId': amityUser.userId,
                },
              );
            }
          },
          style: themeData.textTheme.titleMedium!,
        );
      }
      return Container();
    }

    if (amityPostData is ImageData) {
      final data = amityPostData as ImageData;
      if (data.image != null) {
        return SizedBox(
          width: 100,
          height: 100,
          child: (data.image != null)
              ? Image.network(
                  data.image!.getUrl(AmityImageSize.MEDIUM),
                  fit: BoxFit.cover,
                )
              : Text("MEDIA DELETED"),
        );
      }
    }

    if (amityPostData is VideoData) {
      final data = amityPostData as VideoData;
      return (data.fileId != null)? SizedBox(
        width: 100,
        height: 100,
        // color: Colors.red,
        child: (data.thumbnail != null && data.fileId != null)
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      data.thumbnail?.getUrl(AmityImageSize.MEDIUM) ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        data.getVideo(AmityVideoQuality.HIGH).then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullScreenVideoPlayer(
                                title: value.fileName!,
                                url: value.fileUrl!,
                              ),
                            ),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            : Text("MEDIA DELETED"),
      ):Container(
              width: 20,
              height: 20,
              color: Colors.amber,
            );
    }

    if (amityPostData is FileData) {
      final data = amityPostData as FileData;
      return (data.fileId != null)
          ? TextButton.icon(
              onPressed: () {
                launch(data.fileInfo.fileName!);
              },
              icon: const Icon(Icons.attach_file_rounded, color: Colors.blue),
              label: Text(
                data.fileInfo.fileName!,
                style:
                    themeData.textTheme.bodyLarge!.copyWith(color: Colors.blue),
              ),
            )
          : Container(
              width: 20,
              height: 20,
              color: Colors.amber,
            );
    }

    if (amityPostData is PollData) {
      final data = amityPostData as PollData;
      return Container(
        // color: Colors.green,
        child: PollWidget(data: data , createdbyUserId:  amityPost.postedUserId!,),
      );
    }

    return Container(
      color: Colors.red,
      child: Text('>>>>> $amityPostData <<<<<<'),
    );
  }
}

class FeedReactionInfoWidget extends StatelessWidget {
  final AmityPost amityPost;
  const FeedReactionInfoWidget({Key? key, required this.amityPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              GoRouter.of(context).pushNamed(AppRoute.postReaction,
                  params: {'postId': amityPost.postId!});
              // amityPost.getReaction().getPagingData().then((value) {
              //   print(value);
              // });
            },
            icon: Image.asset(
              'assets/ic_liked.png',
              height: 18,
              width: 18,
            ),
            label: Text(
              '${amityPost.reactionCount}',
              style: themeData.textTheme.titleMedium!
                  .copyWith(color: Colors.black54),
            ),
          ),
          const Spacer(),
          Text(
            '${amityPost.commentCount} Comment',
            style: themeData.textTheme.titleMedium!
                .copyWith(color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Text(
            '${amityPost.flagCount} Flag',
            style: themeData.textTheme.titleMedium!
                .copyWith(color: Colors.black54),
          )
        ],
      ),
    );
  }
}

class FeedReactionActionWidget extends StatelessWidget {
  final AmityPost amityPost;
  final VoidCallback onCommentCallback;
  FeedReactionActionWidget(
      {Key? key, required this.amityPost, required this.onCommentCallback})
      : super(key: key);
  final LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isFlagedByMe = amityPost.myReactions?.isNotEmpty ?? false;
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CompositedTransformTarget(
            link: link,
            child: TextButton.icon(
              onPressed: () {
                if (isFlagedByMe) {
                  amityPost.react().removeReaction('like').then((value) {
                    print(value.myReactions);
                  });
                } else {
                  amityPost.react().addReaction('like').then((value) {
                    print(value.myReactions);
                  });
                }
              },
              onLongPress: () {
                //Show more option to react
                ReactionActionWidget.showAsOverLay(
                  context,
                  link,
                  (reaction) {
                    if (isFlagedByMe) {
                      amityPost.react().removeReaction(reaction);
                    } else {
                      amityPost.react().addReaction(reaction);
                    }
                  },
                );
              },
              icon: Image.asset(
                isFlagedByMe ? 'assets/ic_liked.png' : 'assets/ic_like.png',
                height: 18,
                width: 18,
              ),
              label: Text(
                'Like',
                style: themeData.textTheme.titleMedium!.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onCommentCallback,
            icon: const ImageIcon(AssetImage('assets/ic_comment.png')),
            label: Text(
              'Comment',
              style: themeData.textTheme.titleMedium!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.w600),
            ),
          ),
          Visibility(
            visible: true,
            child: TextButton.icon(
              onPressed: () {
                if (amityPost.isFlaggedByMe) {
                  amityPost.report().unflag().then((value) {
                    CommonSnackbar.showPositiveSnackbar(
                        context, 'Success', 'Unflagged the Post');
                  }).onError((error, stackTrace) {
                    CommonSnackbar.showNagativeSnackbar(
                        context, 'Error', error.toString());
                  });
                } else {
                  amityPost.report().flag().then((value) {
                    CommonSnackbar.showPositiveSnackbar(
                        context, 'Success', 'Flag the Post');
                  }).onError((error, stackTrace) {
                    CommonSnackbar.showNagativeSnackbar(
                        context, 'Error', error.toString());
                  });
                }
              },
              icon: amityPost.isFlaggedByMe
                  ? const ImageIcon(
                      AssetImage('assets/ic_flagged.png'),
                    )
                  : const ImageIcon(
                      AssetImage('assets/ic_flag.png'),
                    ),
              // icon: Image.asset('assets/ic_comment.png'),
              label: Text(
                amityPost.isFlaggedByMe ? 'Falgged' : 'Flag',
                style: themeData.textTheme.titleMedium!.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
