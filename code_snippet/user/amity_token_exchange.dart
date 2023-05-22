import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';

class AmityTokenExchange {
  /* begin_sample_code
    gist_id: bda5eaac608897a6f382a5126d35d4a0
    filename: AmityAuthentication.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter exchange token example
    */
  void createUserToken(String userId, String displayname, String secureToken) {
    AmityUserTokenManager(
            apiKey: "your api key", endpoint: AmityRegionalHttpEndpoint.SG)
        //displayname and secureToken are optional
        .createUserToken(userId,
            displayname: displayname, secureToken: secureToken)
        .then((AmityUserToken token) {
            log("accessToken = ${token.accessToken}");
    });
  }
  /* end_sample_code */

}
