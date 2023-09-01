import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityVideoUpload {
  /* begin_sample_code
    gist_id: 6a1ea5fee0a85151699e40bedccc534c
    filename: AmityVideoUpload.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter Video upload with progress example
    */
  void uploadVideo(File uploadingVideo) async {
    AmityCoreClient.newFileRepository()
        .uploadVideo(uploadingVideo)
        .stream
        .listen((AmityUploadResult<AmityVideo> amityResult) {
      amityResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //handle result
          AmityVideo uploadedVideo = file;
        },
        error: (error) {
          final AmityException amityException = error;
          // handle error
        },
        cancel: () {
          // handle cancel request
        },
      );
    });
  }
  /* end_sample_code */
}
