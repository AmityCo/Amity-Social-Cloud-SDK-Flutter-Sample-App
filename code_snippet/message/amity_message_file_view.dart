import 'package:amity_sdk/amity_sdk.dart';

class AmityMessageFileView {
  /* begin_sample_code
    gist_id: 11e1b2dcf207655fafe1e017d922eca8
    filename: AmityMessageFileView.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter message file view example
    */
  void viewFileMessage(AmityMessage message) {
    if (message.data is MessageFileData) {
      final fileName = (message.data as MessageFileData).file!.fileName;
      final fileUrl = (message.data as MessageFileData).file!.getUrl;
    }
  }
  /* end_sample_code */
}
