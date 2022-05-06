class AppRoute {
  static const home = 'home';
  static const homeRoute = '/home';

  static const login = 'login';
  static const loginRoute = '/login';

  static const profile = 'profile';
  static const profileRoute = 'profile/:userId';

  static const createPost = 'createPost';
  static const createPostRoute = 'createPost/:userId';

  static const userFeed = 'userFeed';
  static const userFeedRoute = 'userFeed/:userId';

  static const globalFeed = 'globalFeed';
  static const globalFeedRoute = 'globalFeed';

  static const communityFeed = 'communityFeed';
  static const communityFeedRoute = 'communityFeed/:communityId';
}
