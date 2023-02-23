import 'package:amity_sdk/amity_sdk.dart';

class AmityPostTextRemoveMention {
  /* begin_sample_code
    gist_id: 56a9c62d96cf362b81247b5d80c7b165
    filename: AmityPostTextRemoveMention.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter remove mention from text post example
    */

  void updateTextPostWithMention(AmityPost post) {
    const userIds = <String>[];
    final mentionMetadataCreator = <String, dynamic>{};

    //Replace mention data with empty data
    post
        .edit()
        .text('updated post content')
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
