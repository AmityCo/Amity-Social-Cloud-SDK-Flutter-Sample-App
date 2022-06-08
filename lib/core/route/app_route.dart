class AppRoute {
  static const home = 'home';
  static const homeRoute = '/home';

  static const login = 'login';
  static const loginRoute = '/login';

  static const profile = 'profile';
  static const profileRoute = 'profile/:userId';

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

  //community Routes
  static const communityList = 'communityList';
  static const communityListRoute = 'communityList';

  static const communityTrendingList = 'communityTrendingList';
  static const communityTrendingListRoute = 'communityTrendingList';

  static const communityRecommendedList = 'communityRecommendedList';
  static const communityRecommendedListRoute = 'communityRecommendedList';

  static const communityProfile = 'communityProfile';
  static const communityProfileRoute = 'communityProfile/:communityId';

  static const communityFeed = 'communityFeed';
  static const communityFeedRoute = 'communityFeed/:communityId';

  static const communityMember = 'communityMember';
  static const communityMemmberRoute = 'communityMember/:communityId';

  static const createCommunity = 'createCommunity';
  static const createCommunityRoute = 'createCommunity';

  static const updateCommunity = 'updateCommunity';
  static const updateCommunityRoute = 'updateCommunity/:communityId';
}
