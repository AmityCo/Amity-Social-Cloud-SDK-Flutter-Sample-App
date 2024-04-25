import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/reaction_action_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/video_player/full_screen_video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class StoryWidget extends StatelessWidget {
  final AmityStory story;
  final AmityStoryTargetType targetType;
  final String targetId;
  final bool disableAction;
  const StoryWidget(
      {super.key,
      required this.story,
      required this.targetType,
      required this.targetId,
      this.disableAction = false});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Stack(
      fit: StackFit.loose,
      children: [
        ShadowContainerWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileInfoRowWidget(
                userId: story.creatorPublicId!,
                userAvatar:
                    story.creator?.avatarUrl ?? story.creator?.avatarCustomUrl,
                userName: story.creator!.displayName!,
                options: disableAction
                    ? null
                    : [
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 0,
                                enabled: true,
                                child: Text("Delete (Hard)"),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                enabled: true,
                                child: Text("Delete (Soft)"),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                enabled: true,
                                child: Text("Mark Story as Viewed"),
                              ),
                              const PopupMenuItem(
                                value: 3,
                                enabled: true,
                                child: Text("Mark Story as Clicked"),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                enabled: true,
                                child: Text("Subscribe RTE"),
                              ),
                            ];
                          },
                          child: const Icon(
                            Icons.more_vert,
                            size: 18,
                          ),
                          onSelected: (index) {
                            if (index == 0) {
                              AmitySocialClient.newStoryRepository()
                                  .hardDeleteStory(storyId: story.storyId!)
                                  .onError((error, stackTrace) {
                                print(error.toString());
                                print(stackTrace.toString());
                                CommonSnackbar.showNagativeSnackbar(
                                    context, 'Error', error.toString());
                              });
                            }
                            if (index == 1) {
                              AmitySocialClient.newStoryRepository()
                                  .softDeleteStory(storyId: story.storyId!)
                                  .onError((error, stackTrace) {
                                print(error.toString());
                                print(stackTrace.toString());
                                CommonSnackbar.showNagativeSnackbar(
                                    context, 'Error', error.toString());
                              });
                            }

                            if (index == 2) {
                              story.analytics().markAsSeen();
                            }
                            if (index == 3) {
                              story.analytics().markLinkAsClicked();
                            }
                            if (index == 4) {
                              story.subscription();
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
                      'Created At - ${story.createdAt!.format()}',
                      style: themeData.textTheme.bodySmall,
                    ),
                    Text(
                      'Updated At - ${story.updatedAt?.format()}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Target Type  -> ${story.targetType?.value}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Target Type  -> ${story.targetId}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Story ID - ${story.storyId!}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Sync State -> ${story.syncState?.value}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Date Type  -> ${story.dataType?.value}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    SelectableText(
                      'Story Item Count  -> ${story.storyItems.length}',
                      style: themeData.textTheme.bodySmall,
                    ),

                    story.storyItems.length > 0
                        ? const Text("Story Items")
                        : Container(),
                    for (var storyItem in story.storyItems)
                      SelectableText(
                        'HyperLink text  -> ${storyItem.toJson()}',
                        style: themeData.textTheme.bodySmall,
                      ),

                    // if (story.targetType is AmityStoryTargetType.COMMUNITY)
                    //   Text(
                    //     'Posted On : ${(value.target as UserTarget).targetUser?.displayName ?? 'No name'}',
                    //     style: themeData.textTheme.bodySmall,
                    //   ),
                    // if (value.target is CommunityTarget)
                    //   Text(
                    //     'Posted On : ${(value.target as CommunityTarget).targetCommunity?.displayName ?? 'No name'} Community',
                    //     style: themeData.textTheme.bodySmall,
                    //   ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (story.data != null)
                      StoryContentWidget(
                        story: story,
                        storyData: story.data!,
                      ),
                    Divider(height: .5, color: Colors.grey.shade300),
                    Container(
                        key: UniqueKey(),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: FeedReactionInfoWidget(amityStory: story)),
                    Divider(height: .5, color: Colors.grey.shade300),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        // GoRouter.of(context).pushNamed(
                        //     AppRoute.getReachUser,
                        //     queryParams: {
                        //       'postId': value.postId!,
                        //     });
                      },
                      child: Row(
                        children: [
                          Text("Impressions: ${story.impression}"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Reach: ${story.reach}"),
                        ],
                      ),
                    ),
                    Divider(height: .5, color: Colors.grey.shade300),
                    const SizedBox(
                      height: 10,
                    ),
                    // Text("Is Seen: ${story.isSeen() ? 'Yes' : 'No'}"),
                    // Divider(height: .5, color: Colors.grey.shade300),
                    const SizedBox(
                      height: 10,
                    ),
                    FeedReactionActionWidget(
                        amityStory: story,
                        onCommentCallback: () {
                          GoRouter.of(context).pushNamed(
                            AppRoute.commentList,
                            queryParams: {
                              'referenceType': 'story',
                              'referenceId': story.storyId!,
                              'communityId': story.targetId,
                              'isPublic': true.toString()
                            },
                          );
                        }),
                  ],
                ),
              ),
              AddCommentWidget(
                AmityCoreClient.getCurrentUser(),
                (text, user, attachments) {
                  final mentionUsers = <AmityUser>[];

                  mentionUsers.clear();
                  mentionUsers.addAll(user);

                  //Clean up mention user list, as user might have removed some tagged user
                  mentionUsers.removeWhere(
                      (element) => !text.contains(element.displayName!));

                  final amityMentioneesMetadata = mentionUsers
                      .map<AmityUserMentionMetadata>((e) =>
                          AmityUserMentionMetadata(
                              userId: e.userId!,
                              index: text.indexOf('@${e.displayName!}'),
                              length: e.displayName!.length))
                      .toList();

                  Map<String, dynamic> metadata =
                      AmityMentionMetadataCreator(amityMentioneesMetadata)
                          .create();

                  AmitySocialClient.newCommentRepository()
                      .createComment()
                      .story(story.storyId!)
                      .create()
                      .text(text)
                      .mentionUsers(
                          mentionUsers.map<String>((e) => e.userId!).toList())
                      .metadata(metadata)
                      .send();
                },
                communityId: targetId,
                isPublic: true,
              ),
            ],
          ),
        ),
        if (story.isDeleted ?? false)
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
    ;
  }
}

class StoryContentWidget extends StatelessWidget {
  final AmityStory story;
  final AmityStoryData storyData;
  const StoryContentWidget(
      {super.key, required this.story, required this.storyData});

  @override
  Widget build(BuildContext context) {
    if (storyData is ImageStoryData) {
      final data = storyData as ImageStoryData;
      if (data.image.hasLocalPreview != null) {
        return Column(
          children: [
            Text("Image Display Mode ${data.imageDisplayMode.value}"),
            SizedBox(
              width: 100,
              height: 100,
              child: (data.image.hasLocalPreview!)
                  ? Image.file(
                      File(data.image.getFilePath!),
                      fit: BoxFit.cover,
                    )
                  : (data.image != null)
                      ? Image.network(
                          data.image!.getUrl(AmityImageSize.MEDIUM),
                          fit: BoxFit.cover,
                        )
                      : Text("MEDIA DELETED"),
            ),
          ],
        );
      }
    }
    if (storyData is VideoStoryData) {
      final data = storyData as VideoStoryData;
      return Column(
        children: [
          SelectableText(
            'Thumbnail  -> ${data.thumbnail.fileUrl ?? 'No Thumbnail'}',
          ),
          SelectableText(
            'Video Resolutions  -> ${data.video.getResolutions() ?? 'No Resolution'}',
          ),
          (data.video.hasLocalPreview != null)
              ? (data.video.hasLocalPreview!)
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: MiniVideoPlayer(uri: data.video.getFilePath!),
                    )
                  : SizedBox(
                      width: 100,
                      height: 100,
                      // color: Colors.red,
                      child: (data.thumbnail != null &&
                              data.video.fileId != null)
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    data.thumbnail
                                            ?.getUrl(AmityImageSize.MEDIUM) ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FullScreenVideoPlayer(
                                            title: data.video.fileName!,
                                            url: data.video.fileUrl!,
                                          ),
                                        ),
                                      );
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
                    )
              : (data.video != null)
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      // color: Colors.red,
                      child: (data.thumbnail != null &&
                              data.video.fileId != null)
                          ? Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    data.thumbnail
                                            ?.getUrl(AmityImageSize.MEDIUM) ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FullScreenVideoPlayer(
                                            title: data.video.fileName!,
                                            url: data.video.fileUrl!,
                                          ),
                                        ),
                                      );
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
                    )
                  : Container(
                      width: 20,
                      height: 20,
                      color: Colors.amber,
                    )
        ],
      );
    }
    if (storyData is UnknownStoryData) {}

    return const Placeholder();
  }
}

class MiniVideoPlayer extends StatefulWidget {
  final String uri;
  const MiniVideoPlayer({super.key, required this.uri});

  @override
  State<MiniVideoPlayer> createState() => _MiniVideoPlayerState();
}

class _MiniVideoPlayerState extends State<MiniVideoPlayer> {
  late ChewieController chewieController;
  @override
  void initState() {
    print("MiniVideoPlaye   --->      URI ${widget.uri}");
    setUpChewie();
    super.initState();
  }

  void setUpChewie() {
    final videoPlayerController = VideoPlayerController.file(File(widget.uri));
    videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return chewieController != null &&
            chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(
            controller: chewieController!,
          )
        : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          );
  }
}

class FeedReactionInfoWidget extends StatelessWidget {
  final AmityStory amityStory;
  const FeedReactionInfoWidget({Key? key, required this.amityStory})
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
              GoRouter.of(context).pushNamed(AppRoute.storyReaction,
                  params: {'storyId': amityStory.storyId!});
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
              '${amityStory.reactionCount}',
              style: themeData.textTheme.titleMedium!
                  .copyWith(color: Colors.black54),
            ),
          ),
          const Spacer(),
          Text(
            '${amityStory.commentCount} Comment',
            style: themeData.textTheme.titleMedium!
                .copyWith(color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Text(
            '${amityStory.flagCount} Flag',
            style: themeData.textTheme.titleMedium!
                .copyWith(color: Colors.black54),
          )
        ],
      ),
    );
  }
}

class FeedReactionActionWidget extends StatelessWidget {
  final AmityStory amityStory;
  final VoidCallback onCommentCallback;
  FeedReactionActionWidget(
      {Key? key, required this.amityStory, required this.onCommentCallback})
      : super(key: key);
  final LayerLink link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isFlagedByMe = amityStory.myReactions.isNotEmpty;
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
                  AmitySocialClient.newReactionRepository()
                      .removeReaction(
                          AmityStoryReactionReference(
                              referenceId: amityStory.storyId!),
                          'like')
                      .then((value) {
                    print(value.myReactions);
                  });
                } else {
                  AmitySocialClient.newReactionRepository()
                      .addReaction(
                          AmityStoryReactionReference(
                              referenceId: amityStory.storyId!),
                          'like')
                      .then((value) {
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
                      AmitySocialClient.newReactionRepository().removeReaction(
                          AmityStoryReactionReference(
                              referenceId: amityStory.storyId!),
                          reaction);
                    } else {
                      AmitySocialClient.newReactionRepository().addReaction(
                          AmityStoryReactionReference(
                              referenceId: amityStory.storyId!),
                          reaction);
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
          // Visibility(
          //   visible: true,
          //   child: TextButton.icon(
          //     onPressed: () {
          //       if (amityStory.isFlaggedByMe) {
          //         amityPost.report().unflag().then((value) {
          //           CommonSnackbar.showPositiveSnackbar(
          //               context, 'Success', 'Unflagged the Post');
          //         }).onError((error, stackTrace) {
          //           CommonSnackbar.showNagativeSnackbar(
          //               context, 'Error', error.toString());
          //         });
          //       } else {
          //         amityStory.report().flag().then((value) {
          //           CommonSnackbar.showPositiveSnackbar(
          //               context, 'Success', 'Flag the Post');
          //         }).onError((error, stackTrace) {
          //           CommonSnackbar.showNagativeSnackbar(
          //               context, 'Error', error.toString());
          //         });
          //       }
          //     },
          //     icon: amityPost.isFlaggedByMe
          //         ? const ImageIcon(
          //             AssetImage('assets/ic_flagged.png'),
          //           )
          //         : const ImageIcon(
          //             AssetImage('assets/ic_flag.png'),
          //           ),
          //     // icon: Image.asset('assets/ic_comment.png'),
          //     label: Text(
          //       amityPost.isFlaggedByMe ? 'Falgged' : 'Flag',
          //       style: themeData.textTheme.titleMedium!.copyWith(
          //           color: Colors.black54, fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
