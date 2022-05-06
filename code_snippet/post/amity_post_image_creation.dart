import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityPostImageCreation {
  /* begin_sample_code
    gist_id: 53e67894a1e6baa80c99ef4681a50ea4
    filename: AmityPostImageCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create image post example
    */
  void uploadImage(File uploadingImage) {
    //first, upload image
    AmityCoreClient.newFileRepository()
        .image(uploadingImage)
        .upload()
        .then((AmityUploadResult<AmityImage> amityUploadResult) {
      //check if the upload result is complete
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        //cast amityUploadResult to AmityImage
        AmityImage uploadedImage = amityUploadComplete.getFile as AmityImage;
        //then create an image post
        createImagePost(uploadedImage);
      }
      //check if the upload result is complete
      else if (amityUploadResult is AmityUploadError) {
        final amityUploadError = amityUploadResult as AmityUploadError;
        final AmityException amityException = amityUploadError.getErrror;
        //handle error
      }
    });
  }

  void createImagePost(AmityImage uploadedImage) {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(
            'userId') // or targetMe(), targetCommunity(communityId: String)
        .image([uploadedImage])
        .text('Hello from flutter with image!')
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
