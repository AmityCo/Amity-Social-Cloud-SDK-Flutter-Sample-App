import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';
import 'package:flutter_social_sample_app/core/widget/post_live_object_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/text_check_box_widget.dart';
import 'package:go_router/go_router.dart';

class PostRteEventScreen extends StatefulWidget {
  const PostRteEventScreen({super.key, required this.postId, this.communityId, this.isPublic = false});
  final String postId;
  final String? communityId;
  final bool isPublic;
  @override
  State<PostRteEventScreen> createState() => _PostRteEventScreenState();
}

class _PostRteEventScreenState extends State<PostRteEventScreen> {
  AmityPost? _post;

  final eventPool = <String, bool>{};

  late Future<AmityPost> _amityPostFuture;
  @override
  void initState() {
    _amityPostFuture = AmitySocialClient.newPostRepository().getPost(widget.postId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Unsubscribe to all post events
        for (var event in AmityPostEvents.values) {
          _post!.subscription(event).unsubscribeTopic();
        }

        GoRouter.of(context).pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subscribe Post'),
        ),
        body: Container(
          child: FutureBuilder(
            future: _amityPostFuture,
            initialData: _post,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                _post = snapshot.data as AmityPost;
                _post!;
                return Container(
                  child: Column(
                    children: [
                      ShadowContainerWidget(
                        child: Row(
                          children: [
                            ...List.generate(
                              AmityPostEvents.values.length,
                              (index) => TextCheckBox(
                                title: AmityPostEvents.values[index].name,
                                value: eventPool[AmityPostEvents.values[index].name] ?? false,
                                onChanged: (value) {
                                  eventPool[AmityPostEvents.values[index].name] = value ?? false;

                                  if (eventPool[AmityPostEvents.values[index].name] ?? false) {
                                    ///Subscribe to the event
                                    _post!.subscription(AmityPostEvents.values[index]).subscribeTopic().then((value) {
                                      CommonSnackbar.showPositiveSnackbar(
                                          context, 'Success', 'Subcribed to ${AmityPostEvents.values[index].name}');
                                    }).onError((error, stackTrace) {
                                      CommonSnackbar.showNagativeSnackbar(context, 'Error',
                                          'Failed to subscribe to ${AmityPostEvents.values[index].name}');
                                    });
                                  } else {
                                    ///Unsubscribe to the event
                                    _post!.subscription(AmityPostEvents.values[index]).unsubscribeTopic().then((value) {
                                      CommonSnackbar.showPositiveSnackbar(
                                          context, 'Success', 'Unsubcribed to ${AmityPostEvents.values[index].name}');
                                    }).onError((error, stackTrace) {
                                      CommonSnackbar.showNagativeSnackbar(context, 'Error',
                                          'Failed to unsubscribe to ${AmityPostEvents.values[index].name}');
                                    });
                                  }
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      PostLiveOjectWidget(
                        amityPost: _post!,
                        communityId: widget.communityId,
                        isPublic: widget.isPublic,
                        disableAction: true,
                        disableAddComment: true,
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error - ${snapshot.error.toString()}'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
