import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityUserAvatar {
  /* begin_sample_code
    gist_id: 8941d21c7d88af572a7f4aa897098f61
    filename: AmityUserAvatar.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter user avatar update example
    */
  void uploadAvatar(File imageFile) {
    AmityCoreClient.newFileRepository()
        .image(imageFile)
        .upload()
        .then((AmityUploadResult<AmityImage> amityResult) {
      //handle result
      if (amityResult is AmityUploadComplete) {
        final amityUploadComplete = amityResult as AmityUploadComplete;
        //cast amityUploadResult to AmityImage
        final uploadedImage = amityUploadComplete.getFile as AmityImage;
        //proceed result with uploadedImage
        updateUserAvatar(uploadedImage.fileId);
      }

      if (amityResult is AmityUploadError) {
        //handle error
      }
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }

  void updateUserAvatar(String avatarFileId) {
    AmityCoreClient.newUserRepository()
        .updateUser('userId')
        .avatarFileId(avatarFileId)
        .update()
        .then((AmityUser user) {
      //handle result
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
