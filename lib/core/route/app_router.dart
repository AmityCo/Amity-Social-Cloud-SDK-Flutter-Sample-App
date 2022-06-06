import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/presentation/screen/comment_query/comment_query_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_create/community_create_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_feed/community_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_list/community_list_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_member/community_member_paging_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_profile/community_profile_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/community_update/community_update_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/create_post/create_post_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/dashboard/dashboar_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/global_feed/global_feed_screen.dart';
import 'package:flutter_social_sample_app/presentation/screen/login/login_screen.dart';
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
              // GoRoute(
              //   name: 'commentUserProfileFeed',
              //   path: 'comment/:postId',
              //   builder: (context, state) =>
              //       CommentQueryScreen(state.params['postId']!),
              // ),
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
            builder: (context, state) => CommunityMemberPagingscreen(
                communityId: state.params['communityId']!),
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
                  ]),
              GoRoute(
                name: AppRoute.updateCommunity,
                path: AppRoute.updateCommunityRoute,
                builder: (context, state) => CommunityUpdateScreen(
                  communityId: state.params['communityId']!,
                ),
              ),
              GoRoute(
                name: AppRoute.createCommunity,
                path: AppRoute.createCommunityRoute,
                builder: (context, state) => const CommunityCreateScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.login,
        path: AppRoute.loginRoute,
        builder: (context, state) => const LoginScreen(),
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
