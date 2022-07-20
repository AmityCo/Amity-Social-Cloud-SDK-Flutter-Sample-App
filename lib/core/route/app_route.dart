class AppRoute {
  static const home = 'home';
  static const homeRoute = '/home';

  static const login = 'login';
  static const loginRoute = '/login';

  static const globalFeed = 'globalFeed';
  static const globalFeedRoute = 'globalFeed';

  static const userFeed = 'userFeed';
  static const userFeedRoute = 'userFeed/:userId';

  static const commentList = 'commentList';
  static const commentListRoute = 'commentList';

  //Create Post Routes
  static const createPost = 'createPost';
  static const createPostRoute = 'createPost/:userId';

  static const createCommunityPostPost = 'createCommunityPost';
  static const createCommunityPostPostRoute = 'createCommunityPost';

  //community flow routes
  static const communityList = 'communityList';
  static const communityListRoute = 'communityList';

  static const communityTrendingList = 'communityTrendingList';
  static const communityTrendingListRoute = 'communityTrendingList';

  static const communityRecommendedList = 'communityRecommendedList';
  static const communityRecommendedListRoute = 'communityRecommendedList';

  static const communityProfile = 'communityProfile';
  static const communityProfileRoute = 'communityProfile/:communityId';

  static const communityInReviewPost = 'communityInReviewPost';
  static const communityInReviewPostRoute = 'communityInReviewPost';

  static const communityPendingPost = 'communityPendingPost';
  static const communityPendingPostRoute = 'communityPendingPost';

  static const communityFeed = 'communityFeed';
  static const communityFeedRoute = 'communityFeed/:communityId';

  static const communityMember = 'communityMember';
  static const communityMemmberRoute = 'communityMember/:communityId';

  static const createCommunity = 'createCommunity';
  static const createCommunityRoute = 'createCommunity';

  static const communityCategory = 'communityCategory';
  static const communityCategoryRoute = 'communityCategory';

  static const updateCommunity = 'updateCommunity';
  static const updateCommunityRoute = 'updateCommunity';

  //User profile flow routes
  static const profile = 'profile';
  static const profileRoute = 'profile/:userId';

  static const followersUser = 'followersUser';
  static const followersUserRoute = 'followersUser';

  static const followingsUser = 'followingsUser';
  static const followingsUserRoute = 'followingsUser';

  static const followersMy = 'followersMy';
  static const followersMyRoute = 'followersMy';

  static const followingsMy = 'followingsMy';
  static const followeringsMyRoute = 'followingsMy';

  static const followersPendingMy = 'followersPendingMy';
  static const followersPendingMyRoute = 'followersPendingMy';

  static const postReaction = 'postReaction';
  static const postReactionRoute = 'postReaction/:postId';

  static const commentReaction = 'commentReaction';
  static const commentReactionRoute = 'commentReaction/:commentId';

  //Token exchange Routes
  static const tokenExchange = 'tokenExchange';
  static const tokenExchangeRoute = 'tokenExchange';

  static const postDetail = 'postDetail';
  static const postDetailRoute = 'postDetail/:postId';

  static const createPollPost = 'createPollPost';
  static const createPollPostRoute = 'createPollPost';
}
