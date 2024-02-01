import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class PostReachedUsersScreen extends StatefulWidget {
  final String postId;
  final bool showAppBar;
  const PostReachedUsersScreen(
      {super.key, this.showAppBar = true, required this.postId});

  @override
  State<PostReachedUsersScreen> createState() => _PostReachedUsersScreenState();
}

class _PostReachedUsersScreenState extends State<PostReachedUsersScreen> {
  late PagingController<AmityUser> _controller;
  final amityUsers = <AmityUser>[];
  bool isLoading = true;
  final scrollcontroller = ScrollController();

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .getViewedUsers()
          .postId(widget.postId)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            if (mounted) {
              setState(() {
                amityUsers.clear();
                amityUsers.addAll(_controller.loadedItems);
                isLoading = false;
              });
            }
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
        isLoading = true;
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.showAppBar ? AppBar(title: const Text('Reached users')) : null,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: amityUsers.isEmpty
              ? isLoading
                  ? const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator())
                  : const Text("No users reached yet")
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollcontroller,
                  itemCount: amityUsers.length,
                  itemBuilder: (context, index) {
                    final amityUser = amityUsers[index];
                    return ListTile(
                      title: Text(amityUser.displayName ?? ''),
                      subtitle: Text(amityUser.userId ?? ''),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(amityUser.avatarUrl ?? ''),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
