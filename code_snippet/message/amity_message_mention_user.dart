import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageMentionUser {
  /* begin_sample_code
    gist_id: a352eb30e135b9ad51f3207ce39d7197
    filename: AmityMessageMentionUser.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message user mention
    */
  void createTextMessageWithUserMention() {
    // mention specific users
    final mentionUsers = List.of(['userIds']);

    AmityChatClient.newMessageRepository()
        .createMessage('channelId')
        .text('hi @sorbh, do you have a second?')
        .metadata(
            <String, dynamic>{}) //flexible data structure for highlighting text
        .mentionUsers(mentionUsers)
        .send()
        .then((value) {
          //handle result
          //message has been sent successfully
        })
        .onError((error, stackTrace) {
          //handle error
        });
  }
  /* end_sample_code */
}
