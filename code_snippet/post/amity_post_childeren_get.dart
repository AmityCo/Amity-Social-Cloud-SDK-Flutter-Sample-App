import 'package:amity_sdk/amity_sdk.dart';

class AmityPostChildrenGet {
  /* begin_sample_code
    gist_id: 1e2cf97b44d5b9b66b5b8f9c2914da56
    filename: AmityPostChildrenGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter get post children example
    */
  void getPost(String postId) {
    AmitySocialClient.newPostRepository()
        .getPost(postId)
        .then((AmityPost post) {
      //parent post text is always TextData
      //from this line you can get the post's text data
      //eg 'Hello bob'
      final textContent = post.data as TextData;
      final childrenPosts = post.children;
      //check if the chidren posts exist in the parent post
      if (childrenPosts?.isNotEmpty == true) {
        childrenPosts?.forEach((AmityPost childPost) {
          //check if the current child post is an image post
          if (childPost.type == AmityDataType.IMAGE) {
            //if the current child post is an image post,
            //we can cast its data to ImageData
            final AmityPostData? amityPostData = childPost.data;
            if (amityPostData != null) {
              final imageData = amityPostData as ImageData;
              //to get the full image url without transcoding
              final largeImageUrl = imageData.getUrl(AmityImageSize.FULL);
            }
          }
        });
      }
    }).onError((error, stackTrace) {
      //handle error
    });
  }
  /* end_sample_code */
}
