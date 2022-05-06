import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityFileUpload {
  /* begin_sample_code
    gist_id: 961f689cc424da0e56bac0a33b93a66a
    filename: AmityFileUpload.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get user example
    */
  void uploadFile(File uploadingFile) async {
    AmityUploadResult<AmityFile> amityUploadResult =
        await AmityCoreClient.newFileRepository().file(uploadingFile).upload();
    //check if the upload result is complete
    if (amityUploadResult is AmityUploadComplete) {
      final amityUploadComplete = amityUploadResult as AmityUploadComplete;
      //cast amityUploadResult to AmityFile
      final AmityFile uploadedFile = amityUploadComplete.getFile as AmityFile;
      //proceed result with uploadedFile
    }
    //check if the upload result is complete
    else if (amityUploadResult is AmityUploadError) {
      final amityUploadError = amityUploadResult as AmityUploadError;
      final AmityException amityException = amityUploadError.getErrror;
      //handle error
    }
  }
  /* end_sample_code */
}
