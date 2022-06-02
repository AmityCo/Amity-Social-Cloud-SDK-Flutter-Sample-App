import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberRemove {
  /* begin_sample_code
    gist_id: 707f432c466854f13bb1c047ec367edc
    filename: AmityCommunityMemberRemove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove community member example
    */
  late PagingController<AmityCommunityMember> _controller;

  void removeMembers(String communityId, List<String> removingMemberIds) {
    AmitySocialClient.newCommunityRepository()
        .membership(communityId)
        .removeMembers(removingMemberIds)
        .then((value) => {
              //handle result
              //success
              //optional: to remove the removed communityMember from the current communityMember collection
              //you will need manually remove the removed communityMember from the collection
              //for example :
              _controller.removeWhere(
                  (element) => removingMemberIds.contains(element.userId))
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
