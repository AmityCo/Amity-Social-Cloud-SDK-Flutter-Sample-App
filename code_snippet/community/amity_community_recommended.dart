import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityRecommended {
  /* begin_sample_code
    gist_id: 37faa26a2ca713e4d3aadf30a7cf9fb6
    filename: AmityCommunityRecommended.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get recommended communities example
    */
  void getRecommendedCommunities() {
    AmitySocialClient.newCommunityRepository()
        .getRecommendedCommunities()
        .then((List<AmityCommunity> trendingCommunites) => {
              //handle result
              //return maximum 5 recommended communities
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
