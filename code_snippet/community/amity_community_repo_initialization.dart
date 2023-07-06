import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityRepoInitialization {
  /* begin_sample_code
    gist_id: 03d04a27b6de0cd52f1baad88d6395e2
    filename: AmityCommunityRepoInitialization.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create community repo example
    */
  void initCommentRepo() {
    AmityCommunityRepository communityRepository = AmitySocialClient.newCommunityRepository();
  }
  /* end_sample_code */
}
