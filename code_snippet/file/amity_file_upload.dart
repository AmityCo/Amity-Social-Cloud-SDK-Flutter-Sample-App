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
    AmityCoreClient.newFileRepository()
        .file(uploadingFile)
        .upload()
        .stream
        .listen((AmityUploadResult<AmityFile> amityUploadResult) {
      amityUploadResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //check if the upload result is complete

          final AmityFile uploadedFile = file;
          //proceed result with uploadedFile
        },
        error: (error) {
          final AmityException amityException = error;
          //handle error
        },
        cancel: () {},
      );
    });
  }
  /* end_sample_code */
}
