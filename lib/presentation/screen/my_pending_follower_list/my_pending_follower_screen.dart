import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/positive_dialog.dart';

class MyPendingFollowerScreen extends StatefulWidget {
  const MyPendingFollowerScreen({Key? key}) : super(key: key);
  @override
  State<MyPendingFollowerScreen> createState() =>
      _MyPendingFollowerScreenState();
}

class _MyPendingFollowerScreenState extends State<MyPendingFollowerScreen> {
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
          .status(AmityFollowStatusFilter.PENDING)
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
        title: const Text('Pending List'),
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
                        // return Container(
                        //   child: Text(
                        //       '${amityFollowRelationship.sourceUserId}_${amityFollowRelationship.targetUserId}'),
                        // );
                        return MyPendingFollowerInfoWidget(
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

class MyPendingFollowerInfoWidget extends StatelessWidget {
  const MyPendingFollowerInfoWidget(
      {Key? key, required this.amityFollowRelationship})
      : super(key: key);
  final AmityFollowRelationship amityFollowRelationship;
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return StreamBuilder<AmityFollowRelationship>(
      initialData: amityFollowRelationship,
      stream: amityFollowRelationship.listen.stream,
      builder: (context, snapshot) {
        final data = snapshot.data!;

        // if (data.status != AmityFollowStatus.ACCEPTED) {
        //   return Container();
        // }

        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(.3)),
                    child: data.sourceUser!.avatarUrl != null
                        ? Image.network(
                            data.sourceUser!.avatarUrl!,
                            fit: BoxFit.fill,
                          )
                        : data.sourceUser!.avatarCustomUrl != null
                            ? Image.network(
                                data.sourceUser!.avatarCustomUrl!,
                                fit: BoxFit.fill,
                              )
                            : Image.asset('assets/user_placeholder.png'),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    data.sourceUser!.displayName ?? 'No Display name',
                    style: _themeData.textTheme.bodyText2,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        data.accept().then((value) {
                          PositiveDialog.show(context,
                              title: 'Accepted',
                              message: 'Acceped the follow reauest');
                        }).onError((error, stackTrace) {
                          ErrorDialog.show(context,
                              title: 'Error',
                              message:
                                  'Error in accept the follow request ${error.toString()}');
                        });
                      },
                      child: const Text('Accept'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        data.decline().then((value) {
                          PositiveDialog.show(context,
                              title: 'Decline',
                              message: 'Decline the follow request');
                        }).onError((error, stackTrace) {
                          ErrorDialog.show(context,
                              title: 'Error',
                              message:
                                  'Error in Decline the follow request ${error.toString()}');
                        });
                      },
                      child: const Text('Denied'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
