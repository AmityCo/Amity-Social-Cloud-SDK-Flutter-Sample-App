import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail - ${widget.postId}'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text('Post Id - ${widget.postId}'),
            FutureBuilder<AmityPost>(
              future: AmitySocialClient.newPostRepository()
                  .getPost('62cbe2e938443200da3e7f73'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FeedWidget(amityPost: snapshot.data!);
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
