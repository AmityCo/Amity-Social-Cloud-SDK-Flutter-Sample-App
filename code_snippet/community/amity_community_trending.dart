import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityTrending {
  /* begin_sample_code
    gist_id: 1ce677c13dde96bb336dfd41a3063499
    filename: AmityCommunityTrending.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get trending communities example
    */
  void getTrendingCommunities() {
    AmitySocialClient.newCommunityRepository()
        .getTrendingCommunities()
        .then((List<AmityCommunity> trendingCommunites) => {
              //handle result
              //return maximum 5 trending communities
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
