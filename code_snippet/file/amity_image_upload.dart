import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityImageUpload {
  /* begin_sample_code
    gist_id: 67d7af32b29baec7988facddc18eec9a
    filename: AmityImageUpload.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter Image upload with progress example
    */
  void uploadImage(File uploadingImage) async {
    AmityCoreClient.newFileRepository()
        .image(uploadingImage)
        .isFullImage(false)
        .upload()
        .stream
        .listen((amityUploadResult) {
      amityUploadResult.when(
        progress: (uploadInfo, cancelToken) {
          int progress = uploadInfo.getProgressPercentage();
        },
        complete: (file) {
          //check if the upload result is complete

          final AmityImage uploadedImage = file;
          //proceed result with uploadedImage
        },
        error: (error) {
          final AmityException amityException = error;
          //handle error
        },
        cancel: () {
          //upload is cancelled
        },
      );
    });
  }
  /* end_sample_code */
}
