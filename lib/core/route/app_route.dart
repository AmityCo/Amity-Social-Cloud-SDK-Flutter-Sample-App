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
  static const commentListRoute = '/commentList';

  static const commentListReply = 'commentListReply';
  static const commentListReplyRoute = '/commentListReply';

  static const landing = 'landing';
  static const landingRoute = '/landing';

  //Create Post Routes
  static const createPost = 'createPost';
  static const createPostRoute = '/createPost';

  //Create Post Routes
  static const createLiveStreamPost = 'createLiveStreamPost';
  static const createLiveStreamPostRoute = '/createLiveStreamPost';

  //community flow routes
  static const communityList = 'communityList';
  static const communityListRoute = 'communityList';

  static const communityTrendingList = 'communityTrendingList';
  static const communityTrendingListRoute = 'communityTrendingList';

  static const communityRecommendedList = 'communityRecommendedList';
  static const communityRecommendedListRoute = 'communityRecommendedList';

  static const communityProfile = 'communityProfile';
  static const communityProfileRoute = 'communityProfile';

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

  static const messageReaction = 'messageReaction';
  static const messageReactionRoute = 'messageReaction/:messageId';

  //Token exchange Routes
  static const tokenExchange = 'tokenExchange';
  static const tokenExchangeRoute = 'tokenExchange';

  static const postDetail = 'postDetail';
  static const postDetailRoute = 'postDetail/:postId';

  static const createPollPost = 'createPollPost';
  static const createPollPostRoute = 'createPollPost';

  static const chat = 'chat';
  static const chatRoute = 'chatRoute/:channelId';

  static const channelProfile = 'channelProfile';
  static const channelProfileRoute = '/channelProfile/:channelId';

  static const channelList = 'channelList';
  static const channelListRoute = '/channelList';

  static const createChannel = 'createChannel';
  static const createChannelRoute = '/createChannel';

  static const updateChannel = 'updateChannel';
  static const updateChannelRoute = '/updateChannel';

  static const updateMessage = 'updateMessage';
  static const updateMessageRoute = '/updateMessage';

  static const globalUserSearch = 'globalUserSearch';
  static const globalUserSearchRoute = '/globalUserSearchRoute';

  static const postRTE = 'postRTE';
  static const postRTERoute = '/postRTE';

  static const commentRTE = 'commentRTE';
  static const commentRTERoute = '/commentRTE';

  static const communityRTE = 'communityRTE';
  static const communityRTERoute = '/communityRTE';

  static const userBlock = 'userBlock';
  static const userBlockRoute = '/userBlock';

  static const stream = 'streamList';
  static const streamRoute = 'streamList';

  static const liveStream = 'livestreamList';
  static const liveStreamRoute = 'livestreamList';

  static const viewStream = 'viewStream';
  static const viewStreamRoute = 'viewStream';

  static const customRanking = 'customRanking';
  static const customRankingRoute = 'customRanking';

  static const getCategory = 'getCategory';
  static const getCategoryRoute = 'getCategory/:categoryId';

}
