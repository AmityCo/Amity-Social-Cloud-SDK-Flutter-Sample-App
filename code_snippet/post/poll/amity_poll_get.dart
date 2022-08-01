import 'package:amity_sdk/amity_sdk.dart';

class AmityPollGet {
  /* begin_sample_code
    gist_id: 5e9e2987b145eb80816678fd1e408d36
    filename: AmityPollGet.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter poll get example
    */
  void getPollPost(AmityPost post) {
    //parent post text is always TextData
    //from this line you can get the post's text data
    //eg 'What are your favorite songs?'
    final textContent = post.data as TextData;
    final childrenPosts = post.children;
    //check if the chidren posts exist in the parent post
    if (childrenPosts?.isNotEmpty == true) {
      childrenPosts?.forEach((AmityPost childPost) {
        //check if the current child post is an poll post
        if (childPost.type == AmityDataType.POLL) {
          //if the current child post is an poll post,
          //we can cast its data to PollData
          final AmityPostData? amityPostData = childPost.data;
          if (amityPostData != null) {
            final pollData = amityPostData as PollData;
            pollData.getPoll().then((AmityPoll poll) {
              //handle poll data here
            });
          }
        }
      });
    }
  }
  /* end_sample_code */
}
