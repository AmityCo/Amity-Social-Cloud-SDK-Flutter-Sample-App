import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageRepoInitialization {
  /* begin_sample_code
    gist_id: e56b7d4110005eafc4f962cb875a07fc
    filename: AmityMessageRepoInitialization.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter init message repo example
    */
  void initMessageRepo() {
    final messageRepository = AmityChatClient.newMessageRepository();
  }
  /* end_sample_code */
}
