import 'package:amity_sdk/amity_sdk.dart';

class PostAPI {
  Future createPost(targetId, post) async {
    await AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(targetId)
        .text(post)
        .post();
  }
}
