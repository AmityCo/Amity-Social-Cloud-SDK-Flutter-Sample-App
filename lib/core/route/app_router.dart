import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/preferences/preference_interface_impl.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/presentation/screen/ads/ads_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/ads/ads_settings_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_create/channel_create_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_list/channel_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_profile/channel_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_update/channel_update_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/chat/chat_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/comment_query_pagination/comment_query_pagination_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/comment_query_reply/comment_query_reply_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_category/community_category_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_create/community_create_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_feed/community_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_in_review_post_list/community_in_review_post_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_recommend_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_trending_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_member/community_member_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_notification_settings/community_notification_settings_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_pending_post/community_pending_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_profile/community_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_update/community_update_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_custom_post/create_custom_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_livestream_post/create_livestream_post.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_poll_post/create_poll_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_post/create_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_story/create_story_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/follower_list/follower_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/following_list/following_list_screend.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_feed/global_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_feed_custom_ranking/global_feed_custom_ranking.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_story_targets/get_global_story_target_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_user_search/global_user_search.dart';
import 'package:flutter_social_sample_app/presentation/screen/landing/landing_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/live_stream_list/live_stream_list.dart';
import 'package:flutter_social_sample_app/presentation/screen/login/login_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/message_update/message_update_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_follower_list/my_follower_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_following_list/my_following_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_pending_follower_list/my_pending_follower_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/post_detail/post_detail_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/post_reached_users/post_reached_users_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list/reaction_list_story_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_comment/reaction_list_comment_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_message/reaction_list_message_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_post/reaction_list_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/rte_event/comment_rte_event_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/rte_event/community_rte_event_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/rte_event/post_rte_event_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/stories_by_targets/get_stories_by_targets_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/story_details/story_details_screens.dart';
import 'package:flutter_social_sample_app/presentation/screen/story_targets_by_targets%20/targets_by_targets_screens.dart';
import 'package:flutter_social_sample_app/presentation/screen/stream_list/stream_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/token_exchange/token_exchange_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_blocked_list/user_blocked_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_feed/user_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_profile/user_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/validate_text/validate_text_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/validate_urls/Validate_URL_Screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/view_stream/view_stream.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoute.loginRoute,
    routes: [
      GoRoute(
        name: AppRoute.home,
        path: AppRoute.homeRoute,
        builder: (context, state) {
          return const DashboardScreen();
        },
        routes: [
          GoRoute(
            name: AppRoute.profile,
            path: AppRoute.profileRoute,
            builder: (context, state) =>
                UserProfileScreen(userId: state.params['userId']!),
            routes: [
              GoRoute(
                name: AppRoute.followersUser,
                path: AppRoute.followersUserRoute,
                builder: (context, state) =>
                    FollowerListScreen(userId: state.params['userId']!),
              ),
              GoRoute(
                name: AppRoute.followingsUser,
                path: AppRoute.followingsUserRoute,
                builder: (context, state) =>
                    FollowingListScreen(userId: state.params['userId']!),
              ),
              GoRoute(
                name: AppRoute.followersMy,
                path: AppRoute.followersMyRoute,
                builder: (context, state) => const MyFollowerListScreen(),
              ),
              GoRoute(
                name: AppRoute.followingsMy,
                path: AppRoute.followeringsMyRoute,
                builder: (context, state) => const MyFollowingListScreen(),
              ),
              GoRoute(
                name: AppRoute.followersPendingMy,
                path: AppRoute.followersPendingMyRoute,
                builder: (context, state) => const MyPendingFollowerScreen(),
              )
            ],
          ),
          GoRoute(
            name: AppRoute.globalFeed,
            path: AppRoute.globalFeedRoute,
            builder: (context, state) => const GlobalFeedScreen(),
            routes: const [],
          ),
          GoRoute(
            name: AppRoute.customRanking,
            path: AppRoute.customRankingRoute,
            builder: (context, state) => const GlobalFeedCustomRankingScreen(),
          ),
          GoRoute(
            name: AppRoute.stream,
            path: AppRoute.streamRoute,
            builder: (context, state) => const StreamListScreen(),
          ),
          GoRoute(
            name: AppRoute.liveStream,
            path: AppRoute.liveStreamRoute,
            builder: (context, state) => const LiveStreamListScreen(),
          ),
          GoRoute(
            name: AppRoute.viewStream,
            path: AppRoute.viewStreamRoute,
            builder: (context, state) {
              AmityStream amityStream = state.extra as AmityStream;
              return ViewStream(stream: amityStream);
            },
          ),
          GoRoute(
            name: AppRoute.communityFeed,
            path: AppRoute.communityFeedRoute,
            builder: (context, state) => CommunityFeedScreen(
              communityId: state.queryParams['communityId']!,
              isPublic: state.queryParams['isPublic'] == 'true',
            ),
          ),
          GoRoute(
            name: AppRoute.communityMember,
            path: AppRoute.communityMemmberRoute,
            builder: (context, state) => CommunityMemberScreen(
                communityId: state.params['communityId']!),
          ),
          GoRoute(
            name: AppRoute.userFeed,
            path: AppRoute.userFeedRoute,
            builder: (context, state) =>
                UserFeedScreen(userId: state.params['userId']!),
          ),
          GoRoute(
            name: AppRoute.communityList,
            path: AppRoute.communityListRoute,
            builder: (context, state) => const CommunityListScreen(),
            routes: [
              GoRoute(
                  name: AppRoute.communityProfile,
                  path: AppRoute.communityProfileRoute,
                  builder: (context, state) => CommunityProfileScreen(
                        communityId: state.queryParams['communityId']!,
                      ),
                  routes: [
                    GoRoute(
                      name: AppRoute.updateCommunity,
                      path: AppRoute.updateCommunityRoute,
                      builder: (context, state) => CommunityUpdateScreen(
                        communityId: state.queryParams['communityId']!,
                      ),
                    ),
                    GoRoute(
                      name: AppRoute.communityInReviewPost,
                      path: AppRoute.communityInReviewPostRoute,
                      builder: (context, state) =>
                          CommunityInReviewPostListScreen(
                              communityId: state.queryParams['communityId']!,
                              isPublic:
                                  state.queryParams['isPublic'] == 'true'),
                    ),
                    GoRoute(
                      name: AppRoute.communityPendingPost,
                      path: AppRoute.communityPendingPostRoute,
                      builder: (context, state) =>
                          CommunityPendingPostListScreen(
                              communityId: state.queryParams['communityId']!,
                              isPublic:
                                  state.queryParams['isPublic'] == 'true'),
                    ),
                  ]),
              GoRoute(
                name: AppRoute.createCommunity,
                path: AppRoute.createCommunityRoute,
                builder: (context, state) => CommunityCreateScreen(
                  categoryIds: state.queryParams['categoryIds']?.split(','),
                  userIds: state.queryParams['userIds']?.split(','),
                ),
              ),
            ],
          ),
          GoRoute(
            name: AppRoute.tokenExchange,
            path: AppRoute.tokenExchangeRoute,
            builder: (context, state) => const TokenExchangeScreen(),
          ),
          GoRoute(
            name: AppRoute.communityTrendingList,
            path: AppRoute.communityTrendingListRoute,
            builder: (context, state) => const CommunityTrendingListScreen(),
          ),
          GoRoute(
            name: AppRoute.communityRecommendedList,
            path: AppRoute.communityRecommendedListRoute,
            builder: (context, state) => const CommunityRecommendListScreen(),
          ),
          GoRoute(
            name: AppRoute.postReaction,
            path: AppRoute.postReactionRoute,
            builder: (context, state) =>
                ReactionListPostScreen(postId: state.params['postId']!),
          ),
          GoRoute(
            name: AppRoute.storyReaction,
            path: AppRoute.storyReactionRoute,
            builder: (context, state) =>
                ReactionListStoryScreen(referenceId: state.params['storyId']!),
          ),
          GoRoute(
            name: AppRoute.commentReaction,
            path: AppRoute.commentReactionRoute,
            builder: (context, state) => ReactionListCommentScreen(
                commentId: state.params['commentId']!),
          ),
          GoRoute(
            name: AppRoute.messageReaction,
            path: AppRoute.messageReactionRoute,
            builder: (context, state) => ReactionListMessageScreen(
                messageId: state.params['messageId']!),
          ),
          GoRoute(
            name: AppRoute.postDetail,
            path: AppRoute.postDetailRoute,
            builder: (context, state) =>
                PostDetailScreen(postId: state.params['postId']!),
          ),
          GoRoute(
            name: AppRoute.getCategory,
            path: AppRoute.getCategoryRoute,
            builder: (context, state) => CommunityCategoryScreen(
                categoryId: state.params['categoryId']!),
          ),
          GoRoute(
            name: AppRoute.storyDetails,
            path: AppRoute.storyDetailsRoute,
            builder: (context, state) => StoryDetailsScreen(
                storyId: state.params['storyId']!),
          ),
          GoRoute(
            name: AppRoute.storyByTargets,
            path: AppRoute.storyByTargetsRoute,
            builder: (context, state) {

               return GetStoriesByTargetsScreen(
                targets: state.params['targets']!);
            }
          ),

          GoRoute(
            name: AppRoute.storytargetsByTargets,
            path: AppRoute.storytargetsByTargetsRoute,
            builder: (context, state) {

               return GetStoryTargetsByTargets(
                targets: state.params['targets']!);
            }
          ),



          GoRoute(
            name: AppRoute.globalStoryTargets,
            path: AppRoute.globalStoryTargetsRoute,
            builder: (context, state) {

               return const GlobalStoryTargetScreen();
            }
          ),

          GoRoute(
            name: AppRoute.validateText,
            path: AppRoute.validateTextRoute,
            builder: (context, state) {

               return const ValidateTextScreen();
            }
          ),

          GoRoute(
            name: AppRoute.validateURL,
            path: AppRoute.validateURLRoute,
            builder: (context, state) {

               return const ValidateUrlScreen();
            }
          ),

          GoRoute(
            name: AppRoute.createPollPost,
            path: AppRoute.createPollPostRoute,
            builder: (context, state) => const CreatePollPostScreen(),
          ),

           GoRoute(
            name: AppRoute.createCustomPost,
            path: AppRoute.createCustomPostRoute,
            builder: (context, state) => const CreateCustomPostScreen(),
          ),

          GoRoute(
            name: AppRoute.chat,
            path: AppRoute.chatRoute,
            builder: (context, state) =>
                ChatScreen(channelId: state.params['channelId']!),
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.login,
        path: AppRoute.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoute.landing,
        path: AppRoute.landingRoute,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        name: AppRoute.channelProfile,
        path: AppRoute.channelProfileRoute,
        builder: (context, state) => ChannelProfileScreen(
          channelId: state.params['channelId']!,
        ),
      ),
      GoRoute(
        name: AppRoute.channelList,
        path: AppRoute.channelListRoute,
        builder: (context, state) => const ChannelListScreen(),
      ),
      GoRoute(
        name: AppRoute.createChannel,
        path: AppRoute.createChannelRoute,
        builder: (context, state) => const ChannelCreateScreen(),
      ),
      GoRoute(
        name: AppRoute.updateChannel,
        path: AppRoute.updateChannelRoute,
        builder: (context, state) =>
            ChannelUpdateScreen(channelId: state.queryParams['channelId']!),
      ),
      GoRoute(
        name: AppRoute.updateMessage,
        path: AppRoute.updateMessageRoute,
        builder: (context, state) =>
            MessageUpdateScreen(messageId: state.queryParams['messageId']!),
      ),
      GoRoute(
        name: AppRoute.globalUserSearch,
        path: AppRoute.globalUserSearchRoute,
        builder: (context, state) => const GlobalUserSearch(),
      ),
      GoRoute(
        name: AppRoute.createPost,
        path: AppRoute.createPostRoute,
        builder: (context, state) => CreatePostScreen(
          userId: state.queryParams['userId'],
          communityId: state.queryParams['communityId'],
          isPublic: state.queryParams['isPublic'] == 'true',
        ),

        
      ),
      GoRoute(
        name: AppRoute.createStory,
        path: AppRoute.createStoryRoute,
        builder: (context, state) => CreateStoryScreen(
          targetType: AmityStoryTargetTypeExtension.enumOf(
              state.queryParams['targetType']!),
          targetId: state.queryParams['targetId'],
          isVideoType: state.queryParams['isTypeVideo'] == 'true',
        ),

        
      ),
      GoRoute(
        name: AppRoute.createLiveStreamPost,
        path: AppRoute.createLiveStreamPostRoute,
        builder: (context, state) => CreateLiveStreamPostScreen(
          userId: state.queryParams['userId'],
          communityId: state.queryParams['communityId'],
          isPublic: state.queryParams['isPublic'] == 'true',
        ),
      ),
      GoRoute(
        name: AppRoute.commentList,
        path: AppRoute.commentListRoute,
        builder: (context, state) {
          return CommentQueryPaginationScreen(
            referenceType: state.queryParams['referenceType']!,
            referenceId: state.queryParams['referenceId']!,
            communityId: state.queryParams['communityId'],
            isPublic: state.queryParams['isPublic'] == 'true',
          );
        },
      ),
      GoRoute(
        name: AppRoute.commentListReply,
        path: AppRoute.commentListReplyRoute,
        builder: (context, state) {
          return CommentQueryReplyScreen(
            state.queryParams['referenceType']!,
            state.queryParams['referenceId']!,
            state.queryParams['parentCommentId']!,
            communityId: state.queryParams['communityId'],
            isPublic: state.queryParams['isPublic'] == 'true',
          );
        },
      ),
      GoRoute(
        name: AppRoute.postRTE,
        path: AppRoute.postRTERoute,
        builder: (context, state) {
          return PostRteEventScreen(
            postId: state.queryParams['postId']!,
            communityId: state.queryParams['communityId'],
            isPublic: state.queryParams['isPublic'] == 'true',
          );
        },
      ),
      GoRoute(
        name: AppRoute.getReachUser,
        path: AppRoute.getReachUserRoute,
        builder: (context, state) {
          return PostReachedUsersScreen(
            referenceId: state.queryParams['referenceId']!,
            referenceType: state.queryParams['referenceType']!,
          );
        },
      ),
      GoRoute(
        name: AppRoute.commentRTE,
        path: AppRoute.commentRTERoute,
        builder: (context, state) {
          return CommentRteEventScreen(
            commentId: state.queryParams['commentId']!,
            referenceType: state.queryParams['referenceType']!,
            referenceId: state.queryParams['referenceId']!,
            communityId: state.queryParams['communityId'],
            isPublic: state.queryParams['isPublic'] == 'true',
          );
        },
      ),
      GoRoute(
        name: AppRoute.communityRTE,
        path: AppRoute.communityRTERoute,
        builder: (context, state) {
          return CommunityRteEventScreen(
            communityId: state.queryParams['communityId']!,
            // commentId: state.queryParams['commentId']!,
            // postId: state.queryParams['postId']!,
            // communityId: state.queryParams['communityId'],
            // isPublic: state.queryParams['isPublic'] == 'true',
          );
        },
      ),
      GoRoute(
        name: AppRoute.communitNotificationSerttings,
        path: AppRoute.communitNotificationSerttingsRoute,
        builder: (context, state) {
          return CommunityNotificationSettingsScreen(
            communityId: state.queryParams['communityId']!,
          );
        },
      ),

      GoRoute(
        name: AppRoute.userBlock,
        path: AppRoute.userBlockRoute,
        builder: (context, state) {
          return const UserBlockedListScreen();
        },
      ),

      GoRoute(
        name: AppRoute.adsList,
        path: AppRoute.adsListRoute,
        builder: (context, state) {
          return const AdsListScreen();
        },
      ),
    
      GoRoute(
        name: AppRoute.adsSettings,
        path: AppRoute.adsSettingsRoute,
        builder: (context, state) {
          return const AdsSettingsScreen();
        },
      ),
    ],
    redirect: (context, state) async {
      if (state.location == AppRoute.loginRoute) {
        if (!await PreferenceInterfaceImpl().isLoggedIn()) {
          log('redirecting to /login');
          return AppRoute.loginRoute;
        } else {
          var userId = await PreferenceInterfaceImpl().loggedInUserId();
          var userName = await PreferenceInterfaceImpl().loggedInUserDisplayName();
          // Delaying the login for 5 seconds to simulate the login process
          Future.delayed(const Duration(seconds: 5), () { 
            AmityCoreClient.login(userId!)
              .displayName(userName!)
              .submit();
          });
          return AppRoute.homeRoute;
        }
      }
      return null;
    },
    debugLogDiagnostics: true,
  );
}
