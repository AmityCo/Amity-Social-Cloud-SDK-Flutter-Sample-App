import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityPostVideoCreation {
  /* begin_sample_code
    gist_id: 4da70fc3109fff7e3f457b1eb1564f07
    filename: AmityPostVideoCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create video post example
    */
  void uploadVideo(File uploadingVideo) {
    //first, upload video
    AmityCoreClient.newFileRepository()
        .video(uploadingVideo)
        .upload()
        .then((AmityUploadResult<AmityVideo> amityUploadResult) {
      //check if the upload result is complete
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        //cast amityUploadResult to AmityVideo
        AmityVideo uploadedVideo = amityUploadComplete.getFile as AmityVideo;
        //then create a video post
        createVideoPost(uploadedVideo);
      }
      //check if the upload result is complete
      else if (amityUploadResult is AmityUploadError) {
        final amityUploadError = amityUploadResult as AmityUploadError;
        final AmityException amityException = amityUploadError.getErrror;
        //handle error
      }
    });
  }

  void createVideoPost(AmityVideo uploadedVideo) {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(
            'userId') // or targetMe(), targetCommunity(communityId: String)
        .video([uploadedVideo])
        .text('Hello from flutter with video!')
        .post()
        .then((AmityPost post) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
