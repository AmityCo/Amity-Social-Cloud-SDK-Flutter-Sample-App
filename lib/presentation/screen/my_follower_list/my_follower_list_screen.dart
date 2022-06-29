import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';

class MyFollowerListScreen extends StatefulWidget {
  const MyFollowerListScreen({Key? key}) : super(key: key);
  @override
  State<MyFollowerListScreen> createState() => _MyFollowerListScreenState();
}

class _MyFollowerListScreenState extends State<MyFollowerListScreen> {
  late PagingController<AmityFollowRelationship> _controller;
  final amityFollowRelationships = <AmityFollowRelationship>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  // AmityComment? _replyToComment;

  // AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .relationship()
          .me()
          .getFollowers()
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityFollowRelationships.clear();
              amityFollowRelationships.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context,
                title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follower List'),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: amityFollowRelationships.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: amityFollowRelationships.length,
                      itemBuilder: (context, index) {
                        final amityFollowRelationship =
                            amityFollowRelationships[index];
                        return MyFollowerInfoWidget(
                            amityFollowRelationship: amityFollowRelationship);
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Followers'),
                  ),
          ),
          if (_controller.isFetching && amityFollowRelationships.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class MyFollowerInfoWidget extends StatelessWidget {
  const MyFollowerInfoWidget({Key? key, required this.amityFollowRelationship})
      : super(key: key);
  final AmityFollowRelationship amityFollowRelationship;
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return StreamBuilder<AmityFollowRelationship>(
        initialData: amityFollowRelationship,
        stream: amityFollowRelationship.listen,
        builder: (context, snapshot) {
          final data = snapshot.data!;

          if (data.status != AmityFollowStatus.ACCEPTED) {
            return Container();
          }

          return Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.3)),
                  child: data.targetUser!.avatarUrl != null
                      ? Image.network(
                          data.targetUser!.avatarUrl!,
                          fit: BoxFit.fill,
                        )
                      : data.targetUser!.avatarCustomUrl != null
                          ? Image.network(
                              data.targetUser!.avatarCustomUrl!,
                              fit: BoxFit.fill,
                            )
                          : Image.asset('assets/user_placeholder.png'),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                ),
                const SizedBox(width: 12),
                Text(
                  data.targetUser!.displayName ?? 'No Display name',
                  style: _themeData.textTheme.bodyText2,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    data.removeFollower().then((value) {
                      PositiveDialog.show(context,
                          title: 'Unfollow', message: 'User Unfollow');
                    }).onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error',
                          message: 'Error in Unfollow ${error.toString()}');
                    });
                  },
                  child: const Text('Remove'),
                )
              ],
            ),
          );
        });
  }
}