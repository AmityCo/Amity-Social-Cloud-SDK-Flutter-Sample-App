import 'package:amity_sdk/amity_sdk.dart';

class PostAPI {
  Future createPost(targetId, post) async {
    await AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser(targetId)
        .text("C228850 - Make sure can comment on post successfully")
        .post();
  }
}
