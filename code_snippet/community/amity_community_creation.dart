import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';

class AmityCommunityCreation {
  /* begin_sample_code
    gist_id: 551def9b265419880d996d8bdfe8dc6c
    filename: AmityCommunityCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create community example
    */

  //current parent community collection
  late PagingController<AmityCommunity> _controller;

  void createCommunity(AmityImage communityAvatar) {
    AmitySocialClient.newCommunityRepository()
        .createCommunity('Community Name')
        .description('Community Description')
        .avatar(communityAvatar)
        .tags(['tag1', 'tag2'])
        .categoryIds(['categoryId1', 'categoryId2'])
        .isPublic(true) //to choose wether it's public or not
        .metadata({'key': 'value'}) //for extra metadata
        .userIds([
          'userId1, userId2' //include members, you can add or remove later too
        ])
        .create()
        .then((AmityCommunity community) => {
              //handle result
              //optional: to present the created community in to the current community collection
              //you will need manually put the newly created community in to the collection
              //for example :
              _controller.add(community)
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  //(optional) to attach community avatar, it's required to upload image frist.
  void createAvatar(File uploadingImage) {
    // upload image
    AmityCoreClient.newFileRepository()
        .image(uploadingImage)
        .upload()
        .stream
        .listen((amityUploadResult) {
      amityUploadResult.when(
        progress: (uploadInfo, cancelToken) {},
        complete: (file) {
          //check if the upload result is complete
          //then create an image post
          createCommunity(file);
        },
        error: (error) {
          final AmityException amityException = error;
        },
        cancel: () {},
      );
    });
  }
  /* end_sample_code */
}
