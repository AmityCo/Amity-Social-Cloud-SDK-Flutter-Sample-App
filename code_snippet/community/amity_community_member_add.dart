import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityMemberAdd {
  /* begin_sample_code
    gist_id: e4faeae2af37d48fab6ac1d9fa15849c
    filename: AmityCommunityMemberAdd.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter add community member example
    */
  final _amityCommunityMembers = <AmityCommunityMember>[];

  void addMembers(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .membership(communityId)
        .addMembers(['userId1', 'userId2'])
        .then((value) => {
              //handle result
              //optional: to present the added communityMember in to the current replied comment collection
              //you will need manually put the newly added communityMember in to the collection
              //for example :
              // _amityCommunityMembers.add(communityMember)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
