import 'package:amity_sdk/amity_sdk.dart';

class PostAPI {
  Future createPost(String targetId, String post) async {
    try {
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetUser(targetId)
          .text(post)
          .post();
    } catch (e) {
      print(e);
    }
  }
}
