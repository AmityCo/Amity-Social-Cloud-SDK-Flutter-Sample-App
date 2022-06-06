import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/reaction_action_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_post/update_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/video_player/full_screen_video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedWidget extends StatelessWidget {
  final AmityPost amityPost;
  // final VoidCallback onCommentCallback;
  const FeedWidget({Key? key, required this.amityPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return StreamBuilder<AmityPost>(
      stream: amityPost.listen,
      initialData: amityPost,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final value = snapshot.data!;
          return Stack(
            fit: StackFit.loose,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                      ),
                    ]),
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileInfoRowWidget(
                      userId: value.postedUser!.userId!,
                      userAvatar: value.postedUser!.avatarCustomUrl,
                      userName: value.postedUser!.displayName!,
                      options: [
                        if (amityPost.postedUserId ==
                            AmityCoreClient.getUserId())
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return const [
                                PopupMenuItem(
                                  child: Text("Edit"),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  child: Text("Delete (Soft)"),
                                  value: 2,
                                ),
                                PopupMenuItem(
                                  child: Text("Delete (Hard)"),
                                  value: 3,
                                  enabled: false,
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
                                    ),
                                  ),
                                );
                              }
                              if (index == 2) {
                                amityPost.delete();
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
                            'Created At - ' + value.createdAt!.format(),
                            style: _themeData.textTheme.caption,
                          ),
                          Text(
                            'Updated At - ' + value.updatedAt!.format(),
                            style: _themeData.textTheme.caption,
                          ),
                          if (value.target is UserTarget)
                            Text(
                              'Posted On : ' +
                                  ((value.target as UserTarget)
                                          .targetUser
                                          ?.displayName ??
                                      'No name'),
                              style: _themeData.textTheme.caption,
                            ),
                          if (value.target is CommunityTarget)
                            Text(
                              'Posted On : ' +
                                  ((value.target as CommunityTarget)
                                          .targetCommunity
                                          ?.displayName ??
                                      'No name') +
                                  ' Community',
                              style: _themeData.textTheme.caption,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FeedContentWidget(amityPostData: value.data!),
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
                                        style: _themeData.textTheme.bodyText1!
                                            .copyWith(color: Colors.white),
                                      ),
                                    );
                                  }
                                  return FeedContentWidget(
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
                          GoRouter.of(context).pushNamed(AppRoute.commentList,
                              queryParams: {'postId': amityPost.postId!});
                        }),
                    const SizedBox(height: 12),
                    AddCommentWidget(AmityCoreClient.getCurrentUser(), (text) {
                      value.comment().create().text(text).send();
                    }),
                  ],
                ),
              ),
              if (amityPost.isDeleted ?? false)
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
                          style: _themeData.textTheme.bodyText1!
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
  final AmityPostData amityPostData;
  const FeedContentWidget({Key? key, required this.amityPostData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);

    if (amityPostData is TextData) {
      final data = amityPostData as TextData;
      if (data.text != null && data.text!.isNotEmpty) {
        return Text(
          data.text ?? '',
          style: _themeData.textTheme.subtitle1,
        );
      }
      return Container();
    }

    if (amityPostData is ImageData) {
      final data = amityPostData as ImageData;
      return SizedBox(
        width: 100,
        height: 100,
        child: Image.network(
          data.image.getUrl(AmityImageSize.MEDIUM),
          fit: BoxFit.cover,
        ),
      );
    }

    if (amityPostData is VideoData) {
      final data = amityPostData as VideoData;
      return SizedBox(
        width: 100,
        height: 100,
        // color: Colors.red,
        child: Stack(
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
                          title: value.fileName,
                          url: value.fileUrl,
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
        ),
      );
    }

    if (amityPostData is FileData) {
      final data = amityPostData as FileData;
      return TextButton.icon(
        onPressed: () {
          launch(data.fileInfo.fileName);
        },
        icon: const Icon(Icons.attach_file_rounded, color: Colors.blue),
        label: Text(
          data.fileInfo.fileName,
          style: _themeData.textTheme.bodyText1!.copyWith(color: Colors.blue),
        ),
      );
    }

    return Container(
      color: Colors.red,
      child: Text('>>>>> ' + amityPostData.toString() + ' <<<<<<'),
    );
  }
}

class FeedReactionInfoWidget extends StatelessWidget {
  final AmityPost amityPost;
  const FeedReactionInfoWidget({Key? key, required this.amityPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Image.asset(
              'assets/ic_liked.png',
              height: 18,
              width: 18,
            ),
            label: Text(
              '${amityPost.reactionCount}',
              style: _themeData.textTheme.subtitle1!
                  .copyWith(color: Colors.black54),
            ),
          ),
          const Spacer(),
          Text(
            '${amityPost.commentCount} Comment',
            style:
                _themeData.textTheme.subtitle1!.copyWith(color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Text(
            '${amityPost.flagCount} Flag',
            style:
                _themeData.textTheme.subtitle1!.copyWith(color: Colors.black54),
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
    final _themeData = Theme.of(context);
    bool _isFlagedByMe = amityPost.myReactions?.isNotEmpty ?? false;
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CompositedTransformTarget(
            link: link,
            child: TextButton.icon(
              onPressed: () {
                if (_isFlagedByMe) {
                  amityPost.react().removeReaction('like');
                } else {
                  amityPost.react().addReaction('like');
                }
              },
              onLongPress: () {
                //Show more option to react
                ReactionActionWidget.showAsOverLay(
                  context,
                  link,
                  (reaction) {
                    if (_isFlagedByMe) {
                      amityPost.react().removeReaction(reaction);
                    } else {
                      amityPost.react().addReaction(reaction);
                    }
                  },
                );
              },
              icon: Image.asset(
                _isFlagedByMe ? 'assets/ic_liked.png' : 'assets/ic_like.png',
                height: 18,
                width: 18,
              ),
              label: Text(
                'Like',
                style: _themeData.textTheme.subtitle1!.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onCommentCallback,
            // onPressed: () {
            //   GoRouter.of(context).goNamed('commentGlobalFeed',
            //       params: {'postId': amityPost.postId!});
            // },
            icon: const ImageIcon(AssetImage('assets/ic_comment.png')),
            label: Text(
              'Comment',
              style: _themeData.textTheme.subtitle1!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.w600),
            ),
          ),
          Visibility(
            visible: false,
            child: TextButton.icon(
              onPressed: () {},
              icon: const ImageIcon(AssetImage('assets/ic_flag.png')),
              // icon: Image.asset('assets/ic_comment.png'),
              label: Text(
                'Flag',
                style: _themeData.textTheme.subtitle1!.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
