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
        .then((AmityUploadResult<AmityImage> amityUploadResult) {
      //check if the upload result is complete
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        //cast amityUploadResult to AmityImage
        AmityImage uploadedImage = amityUploadComplete.getFile as AmityImage;
        //then create an image post
        createCommunity(uploadedImage);
      }
      //check if the upload result is complete
      else if (amityUploadResult is AmityUploadError) {
        final amityUploadError = amityUploadResult as AmityUploadError;
        final AmityException amityException = amityUploadError.getErrror;
        //handle error
      }
    });
  }
  /* end_sample_code */
}
