import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityDelete {
  /* begin_sample_code
    gist_id: 74fd1344f6fef795471da6b099f0405c
    filename: AmityCommunityDelete.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter delte community example
    */
  //current community collection
  late PagingController<AmityCommunity> _controller;
  void deleteCommunity(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .deleteCommunity(communityId)
        .then((value) => {
              //success
              //optional: to remove the deleted community from the current community collection
              //you will need manually remove the deleted community from the collection
              //for example :
              _controller
                  .removeWhere((element) => element.communityId == communityId)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
