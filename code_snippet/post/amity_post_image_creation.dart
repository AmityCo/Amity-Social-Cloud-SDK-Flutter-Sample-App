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
        .stream
        .listen((AmityUploadResult<AmityImage> amityResult) {
      amityResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //handle result

          //then create a image post
          createImagePost(file);
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

  //current post collection from feed repository
  late PagingController<AmityPost> _controller;

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
              //optional: to present the created post in to the current post collection
              //you will need manually put the newly created post in to the collection
              //for example :
              _controller.add(post)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}
