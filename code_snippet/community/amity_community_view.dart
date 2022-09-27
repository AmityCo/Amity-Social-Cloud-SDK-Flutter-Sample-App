import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/widgets.dart';

class AmityCommunityView {
  /* begin_sample_code
    gist_id: 66260e02d79d4892a6fe5d7af0d3c1be
    filename: AmityCommunityView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter view community example
    */
  void getCommunity(String communityId) {
    AmitySocialClient.newCommunityRepository()
        .getCommunity(communityId)
        .then((value) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  //example of using AmityCommunity with StreamBuilder
  void observeCommunity(AmityCommunity community) {
    StreamBuilder<AmityCommunity>(
        stream: community.listen.stream,
        builder: (context, snapshot) {
          // update widget
          // eg. widget.text = community.displayName
          return Container();
        });
  }

  /* end_sample_code */
}
