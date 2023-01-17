import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageMentionViewHelperCreation {
  /* begin_sample_code
    gist_id: 698788a767f99e6296fbdc21766fc7fa
    filename: AmityMessageMentionViewHelperCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message user and channel mention creation with helper 
    */
  void createTextMessageWithUserMention() {
    const messageText = '@Channel @sorbh hello!';
    final mentionUserIds = List.of(['userId']);

    final mentionMetaData = <AmityMentionMetadata>[];

    // add channel mention as metadata
    mentionMetaData.add(AmityChannelMentionMetadata(index: 0, length: 7));

    // add users mention as metadata
    mentionMetaData
        .add(AmityUserMentionMetadata(userId: "userId", index: 9, length: 5));

    // generating metadata with the helper
    final mentionMetadataJsonObject =
        AmityMentionMetadataCreator(mentionMetaData).create();

    AmityChatClient.newMessageRepository()
        .createMessage('channelId')
        .text(messageText)
        .mentionUsers(mentionUserIds)
        .mentionChannel()
        .metadata(mentionMetadataJsonObject)
        .send()
        .then((value) {
      //handle result
      //message has been sent successfully
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
