import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/video_player/full_screen_video_player.dart';
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
                    const SizedBox(height: 8),
                  ],
                ),
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
    return Chewie(
      controller: chewieController,
    );
  }
}
