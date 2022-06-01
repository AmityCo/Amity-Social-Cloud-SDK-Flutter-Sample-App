class AppRoute {
  static const home = 'home';
  static const homeRoute = '/home';

  static const login = 'login';
  static const loginRoute = '/login';

  static const profile = 'profile';
  static const profileRoute = 'profile/:userId';

  static const createPost = 'createPost';
  static const createPostRoute = 'createPost/:userId';

  static const createCommunityPostPost = 'createCommunityPost';
  static const createCommunityPostPostRoute = 'createCommunityPost';

  static const userFeed = 'userFeed';
  static const userFeedRoute = 'userFeed/:userId';

  static const globalFeed = 'globalFeed';
  static const globalFeedRoute = 'globalFeed';

  static const communityFeed = 'communityFeed';
  static const communityFeedRoute = 'communityFeed/:communityId';

  static const communityMember = 'communityMember';
  static const communityMemmberRoute = 'communityMember/:communityId';

  static const communityList = 'communityList';
  static const communityListRoute = 'communityList';

  static const createCommunity = 'createCommunity';
  static const createCommunityRoute = 'createCommunity';

  static const updateCommunity = 'updateCommunity';
  static const updateCommunityRoute = 'updateCommunity/:communityId';

  static const communityProfile = 'communityProfile';
  static const communityProfileRoute = 'communityProfile/:communityId';
}
