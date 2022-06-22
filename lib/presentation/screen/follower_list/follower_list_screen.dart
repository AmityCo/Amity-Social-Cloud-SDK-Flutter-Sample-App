import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
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
          .user(widget.userId)
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
        actions: const [
          // PopupMenuButton(
          //   itemBuilder: (context) {
          //     return [
          //       PopupMenuItem(
          //         child: Text(AmityCommentSortOption.LAST_CREATED.apiKey),
          //         value: 1,
          //       ),
          //       PopupMenuItem(
          //         child: Text(AmityCommentSortOption.FIRST_CREATED.apiKey),
          //         value: 2,
          //       ),
          //     ];
          //   },
          //   child: const Icon(
          //     Icons.sort_rounded,
          //     size: 24,
          //   ),
          //   onSelected: (index1) {
          //     if (index1 == 1) {
          //       _sortOption = AmityCommentSortOption.LAST_CREATED;
          //       _controller.reset();
          //       _controller.fetchNextPage();
          //     }
          //     if (index1 == 2) {
          //       _sortOption = AmityCommentSortOption.FIRST_CREATED;
          //       _controller.reset();
          //       _controller.fetchNextPage();
          //     }
          //   },
          // )
        ],
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
                        return FollowerInfoWidget(
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

class FollowerInfoWidget extends StatelessWidget {
  const FollowerInfoWidget({Key? key, required this.amityFollowRelationship})
      : super(key: key);
  final AmityFollowRelationship amityFollowRelationship;
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
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
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            child: amityFollowRelationship.sourceUser!.avatarUrl != null
                ? Image.network(
                    amityFollowRelationship.sourceUser!.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : amityFollowRelationship.sourceUser!.avatarCustomUrl != null
                    ? Image.network(
                        amityFollowRelationship.sourceUser!.avatarCustomUrl!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 12),
          Text(
            amityFollowRelationship.sourceUser!.displayName ??
                'No Display name',
            style: _themeData.textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
