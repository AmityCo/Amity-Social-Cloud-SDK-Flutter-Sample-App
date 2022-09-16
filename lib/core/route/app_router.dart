import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/presentation/screen/channel_profile/channel_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/chat/chat_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/comment_query/comment_query_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_create/community_create_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_feed/community_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_in_review_post_list/community_in_review_post_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_recommend_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_trending_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_member/community_member_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_pending_post/community_pending_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_profile/community_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_update/community_update_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_poll_post/create_poll_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_post/create_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/dashboard/dashboar_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/follower_list/follower_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/following_list/following_list_screend.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_feed/global_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/landing/landing_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/login/login_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_follower_list/my_follower_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_following_list/my_following_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/my_pending_follower_list/my_pending_follower_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/post_detail/post_detail_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_comment/reaction_list_comment_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_message/reaction_list_message_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/reaction_list_post/reaction_list_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/token_exchange/token_exchange_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_feed/user_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/user_profile/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoute.homeRoute,
    routes: [
      GoRoute(
        name: AppRoute.home,
        path: AppRoute.homeRoute,
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            name: AppRoute.profile,
            path: AppRoute.profileRoute,
            builder: (context, state) =>
                UserProfileScreen(userId: state.params['userId']!),
            routes: [
              GoRoute(
                name: AppRoute.createPost + '_from_profile',
                path: AppRoute.createPostRoute,
                builder: (context, state) =>
                    CreatePostScreen(userId: state.params['userId']!),
              ),
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
            name: AppRoute.createPost,
            path: AppRoute.createPostRoute,
            builder: (context, state) =>
                CreatePostScreen(userId: state.params['userId']!),
          ),
          GoRoute(
            name: AppRoute.commentList,
            path: AppRoute.commentListRoute,
            builder: (context, state) {
              print('From location - ' + state.location);
              return CommentQueryScreen(state.queryParams['postId']!);
            },
          ),
          GoRoute(
            name: AppRoute.globalFeed,
            path: AppRoute.globalFeedRoute,
            builder: (context, state) => const GlobalFeedScreen(),
            routes: [],
          ),
          GoRoute(
            name: AppRoute.communityFeed,
            path: AppRoute.communityFeedRoute,
            builder: (context, state) =>
                CommunityFeedScreen(communityId: state.params['communityId']!),
            // routes: [
            //   GoRoute(
            //     name: 'commentCommunityFeed',
            //     path: 'comment/:postId',
            //     builder: (context, state) =>
            //         CommentQueryScreen(state.params['postId']!),
            //   ),
            // ],
          ),
          GoRoute(
            name: AppRoute.communityMember,
            path: AppRoute.communityMemmberRoute,
            builder: (context, state) =>
                CommunityMembercreen(communityId: state.params['communityId']!),
          ),
          GoRoute(
            name: AppRoute.userFeed,
            path: AppRoute.userFeedRoute,
            builder: (context, state) =>
                UserFeedScreen(userId: state.params['userId']!),
            // routes: [
            //   GoRoute(
            //     name: 'commentUserFeed',
            //     path: 'comment/:postId',
            //     builder: (context, state) =>
            //         CommentQueryScreen(state.params['postId']!),
            //   ),
            // ],
          ),
          GoRoute(
            name: AppRoute.communityList,
            path: AppRoute.communityListRoute,
            builder: (context, state) => CommunityListScreen(),
            routes: [
              GoRoute(
                  name: AppRoute.communityProfile,
                  path: AppRoute.communityProfileRoute,
                  builder: (context, state) => CommunityProfileScreen(
                        communityId: state.params['communityId']!,
                      ),
                  routes: [
                    GoRoute(
                      name: AppRoute.createCommunityPostPost,
                      path: AppRoute.createCommunityPostPostRoute,
                      builder: (context, state) => CreatePostScreen(
                          communityId: state.params['communityId']!),
                    ),
                    GoRoute(
                      name: AppRoute.updateCommunity,
                      path: AppRoute.updateCommunityRoute,
                      builder: (context, state) => CommunityUpdateScreen(
                        communityId: state.params['communityId']!,
                      ),
                    ),
                    GoRoute(
                      name: AppRoute.communityInReviewPost,
                      path: AppRoute.communityInReviewPostRoute,
                      builder: (context, state) =>
                          CommunityInReviewPostListScreen(
                              communityId: state.params['communityId']!),
                    ),
                    GoRoute(
                      name: AppRoute.communityPendingPost,
                      path: AppRoute.communityPendingPostRoute,
                      builder: (context, state) =>
                          CommunityPendingPostListScreen(
                              communityId: state.params['communityId']!),
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
            name: AppRoute.createPollPost,
            path: AppRoute.createPollPostRoute,
            builder: (context, state) => const CreatePollPostScreen(),
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
    ],
    redirect: (state) {
      if (state.location != AppRoute.loginRoute) {
        return AmityCoreClient.isUserLoggedIn() ? null : AppRoute.loginRoute;
      }
      return null;
    },
    debugLogDiagnostics: true,
  );
}
