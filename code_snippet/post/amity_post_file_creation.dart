import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityPostFileCreation {
  /* begin_sample_code
    gist_id: bd5a3d58f619c5fc89438b5a3ce33618
    filename: AmityPostFileCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create file post example
    */
  void uploadFile(File uploadinFile) {
    //first, upload file
    AmityCoreClient.newFileRepository()
        .uploadFile(uploadinFile)
        .stream
        .listen((AmityUploadResult<AmityFile> amityResult) {
      amityResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //handle result

          //then create a file post
          createFilePost(file);
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

  void createFilePost(AmityFile uploadedFile) {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser('userId') // or targetMe(), targetCommunity(communityId: String)
        .file([uploadedFile])
        .text('Hello from flutter with file!')
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
