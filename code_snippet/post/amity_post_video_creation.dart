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
        .uploadVideo(uploadingVideo , feedtype: AmityContentFeedType.POST)
        .stream
        .listen((AmityUploadResult<AmityVideo> amityResult) {
      amityResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //handle result

          //then create a video post
          createVideoPost(file);
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
