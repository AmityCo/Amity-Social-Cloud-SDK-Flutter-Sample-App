import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class CommunityMembercreen extends StatefulWidget {
  const CommunityMembercreen({Key? key, required this.communityId})
      : super(key: key);
  final String communityId;
  @override
  State<CommunityMembercreen> createState() => _CommunityMemberScreenState();
}

class _CommunityMemberScreenState extends State<CommunityMembercreen> {
  late PagingController<AmityCommunityMember> _controller;
  final amityCommunityMembers = <AmityCommunityMember>[];

  final scrollcontroller = ScrollController();
  bool loading = false;
  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(widget.communityId)
          .getMembers()
          .filter(AmityCommunityMembershipFilter.ALL)
          .sortBy(AmityMembershipSortOption.LAST_CREATED)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityCommunityMembers.clear();
              amityCommunityMembers.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context,
                title: 'Error', message: _controller.error.toString());
          }
        },
      );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
      appBar: AppBar(title: Text('Community Members - ${widget.communityId}')),
      body: Column(
        children: [
          Expanded(
            child: amityCommunityMembers.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityCommunityMembers.length,
                      itemBuilder: (context, index) {
                        final amityCommunityMember =
                            amityCommunityMembers[index];
                        return CommunityMemberWidget(
                          amityCommunityMember: amityCommunityMember,
                          onMemberCallback: () {},
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Members'),
                  ),
          ),
          if (_controller.isFetching && amityCommunityMembers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
