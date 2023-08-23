import 'package:amity_sdk/amity_sdk.dart';

class AmityPostFileGet {
  /* begin_sample_code
    gist_id: bdf7f3acd70eaba01582b0a832c6db80
    filename: AmityPostFileGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get image from post example
    */
  void getFile(AmityPost post) {
    final AmityPostData? amityPostData = post.data;
    if (amityPostData != null) {
      final fileData = amityPostData as FileData;
      final AmityFile amityFile = fileData.file!;
      final String? fileUrl = amityFile.fileUrl;
    }
  }
  /* end_sample_code */
}
