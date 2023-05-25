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
        .uploadImage(imageFile)
        .stream
        .listen((AmityUploadResult<AmityImage> amityResult) {
      amityResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //handle result

          //proceed result with uploadedImage
          updateUserAvatar(file.fileId);
        },
        error: (error) {
          // handle error
        },
        cancel: () {
          // handle cancel request
        },
      );
    });
  }

  void updateUserAvatar(String avatarFileId) {
    AmityCoreClient.newUserRepository().updateUser('userId').avatarFileId(avatarFileId).update().then((AmityUser user) {
      //handle result
    }).onError<AmityException>((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
