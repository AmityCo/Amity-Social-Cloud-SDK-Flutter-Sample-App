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
        .then((AmityUploadResult<AmityVideo> amityUploadResult) {
      //check if the upload result is complete
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        //cast amityUploadResult to AmityVideo
        AmityVideo uploadedVideo = amityUploadComplete.getFile as AmityVideo;
      }
      //check if the upload result is complete
      else if (amityUploadResult is AmityUploadError) {
        final amityUploadError = amityUploadResult as AmityUploadError;
        final AmityException amityException = amityUploadError.getError;
        //handle error
      }
    });
  }
  /* end_sample_code */
}
