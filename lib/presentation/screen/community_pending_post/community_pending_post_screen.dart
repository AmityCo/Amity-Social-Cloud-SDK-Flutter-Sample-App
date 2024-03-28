import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/feed_widget.dart';

class CommunityPendingPostListScreen extends StatefulWidget {
  const CommunityPendingPostListScreen(
      {Key? key,
      required this.communityId,
      this.showAppBar = true,
      required this.isPublic})
      : super(key: key);
  final String communityId;
  final bool isPublic;
  final bool showAppBar;
  @override
  State<CommunityPendingPostListScreen> createState() =>
      _CommunityPendingPostListScreenState();
}

class _CommunityPendingPostListScreenState
    extends State<CommunityPendingPostListScreen> {
  List<AmityPost> amityPosts = <AmityPost>[];
  late PostLiveCollection postLiveCollection;
  bool loading = false;
  final scrollcontroller = ScrollController();
  @override
  void initState() {

    postLiveCollectionInit();

    scrollcontroller.addListener(pagination);

    super.initState();
  }


  void postLiveCollectionInit() {
    postLiveCollection = PostLiveCollection(
        request: () => AmitySocialClient.newPostRepository().getPosts()
          .targetCommunity(widget.communityId)
          .feedType(AmityFeedType.REVIEWING)
          .includeDeleted(false)
            .build());

    postLiveCollection.getStreamController().stream.listen((event) {
      if (mounted) {
        setState(() {
          amityPosts = event;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            (scrollcontroller.position.maxScrollExtent)) &&
        postLiveCollection.hasNextPage()) {
      postLiveCollection.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: Text('Community Feed - ${widget.communityId}'))
          : null,
      body: Column(
        children: [
          Expanded(
            child: amityPosts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      postLiveCollection.reset();
                      postLiveCollectionInit();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: amityPosts.length,
                      itemBuilder: (context, index) {
                        final amityPost = amityPosts[index];
                        return Column(
                          children: [
                            FeedWidget(
                              communityId: widget.communityId,
                              amityPost: amityPost,
                              isPublic: widget.isPublic,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.09)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        amityPost.delete().then((value) {
                                          PositiveDialog.show(context,
                                              title: 'Post',
                                              message: 'Post Delete');
                                        }).onError((error, stackTrace) {
                                          ErrorDialog.show(context,
                                              title: 'Error',
                                              message: error.toString());
                                        });
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: postLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (postLiveCollection.isFetching && amityPosts.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
