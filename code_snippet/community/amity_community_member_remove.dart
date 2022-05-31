import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberRemove {
  /* begin_sample_code
    gist_id: 707f432c466854f13bb1c047ec367edc
    filename: AmityCommunityMemberRemove.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove community member example
    */
  final _amityCommunityMembers = <AmityCommunityMember>[];

  void removeMembers(String communityId, List<String> removingMemberIds) {
    AmitySocialClient.newCommunityRepository()
        .membership(communityId)
        .removeMembers(removingMemberIds)
        .then((value) => {
              //handle result
              //success
              //optional: to remove the removed communityMember from the current post collection
              //you will need manually remove the removed communityMember from the collection
              //for example :
              _amityCommunityMembers.removeWhere(
                  (element) => removingMemberIds.contains(element.userId))
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
