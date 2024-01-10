import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/extension/date_extension.dart';
import 'package:flutter_social_sample_app/core/widget/add_comment_widget.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/user_profile_info_row_widget.dart';
import 'package:flutter_social_sample_app/presentation/screen/update_post/update_post_screen.dart';
import 'package:go_router/go_router.dart';

class PostLiveOjectWidget extends StatelessWidget {
  final String? communityId;
  final bool isPublic;
  final AmityPost amityPost;
  final bool disableAction;
  final bool disableAddComment;
  // final VoidCallback onCommentCallback;
  const PostLiveOjectWidget(
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
      stream: AmitySocialClient.newPostRepository().live.getPost(amityPost.postId!),
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
