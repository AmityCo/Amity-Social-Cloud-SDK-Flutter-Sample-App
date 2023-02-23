import 'package:amity_sdk/amity_sdk.dart';

class AmityCommentTextRemoveMention {
  /* begin_sample_code
    gist_id: 0fc5afeb07da204329f7aedffcd76547
    filename: AmityCommentTextRemoveMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove mention from text comment example
    */

  void updateTextCommentWithMention(AmityComment comment) {
    const userIds = <String>[];
    final mentionMetadataCreator = <String, dynamic>{};

    //Replace mention data with empty data
    comment
        .edit()
        .text('updated comment content')
        .mentionUsers(userIds)
        .metadata(mentionMetadataCreator)
        .build()
        .update()
        .then((post) => {
              //success
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
