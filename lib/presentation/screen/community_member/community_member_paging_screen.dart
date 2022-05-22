import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class CommunityMemberPagingscreen extends StatefulWidget {
  const CommunityMemberPagingscreen({Key? key, required this.communityId})
      : super(key: key);
  final String communityId;
  @override
  State<CommunityMemberPagingscreen> createState() =>
      _CommunityMemberScreenState();
}

class _CommunityMemberScreenState extends State<CommunityMemberPagingscreen> {
  late PagingMediator<AmityCommunityMember> _mediator;
  final amityCommunityMembers = <AmityCommunityMember>[];
  final scrollcontroller = ScrollController();
  bool loading = false;

  @override
  void initState() {
    _mediator = PagingMediator(
      pagingFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(widget.communityId)
          .getMembers()
          .filter(AmityCommunityMembershipFilter.ALL)
          .sortBy(AmityMembershipSortOption.LAST_CREATED)
          .getPagingList(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_mediator.error == null) {
            setState(() {
              amityCommunityMembers.clear();
              amityCommunityMembers.addAll(_mediator.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            ErrorDialog.show(context,
                title: 'Error', message: _mediator.error.toString());
          }
        },
      );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _mediator.fetchNextPage();
    });

    scrollcontroller.addListener(pagination);

    super.initState();
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _mediator.hasMoreItems) {
      setState(() {
        _mediator.fetchNextPage();
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
                      _mediator.reset();
                      _mediator.fetchNextPage();
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
                    child: _mediator.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Members'),
                  ),
          ),
          if (_mediator.isFetching && amityCommunityMembers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mediator.unregister();
    super.dispose();
  }
}
