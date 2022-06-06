import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/community_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:go_router/go_router.dart';

class CommunityListScreen extends StatefulWidget {
  CommunityListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  late PagingController<AmityCommunity> _controller;
  final amityCommunities = <AmityCommunity>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyboard = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityCommunityFilter _filter = AmityCommunityFilter.ALL;
  AmityCommunitySortOption _sort = AmityCommunitySortOption.DISPLAY_NAME;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .getCommunities()
          .withKeyword(_keyboard.isEmpty ? null : _keyboard)
          .sortBy(_sort)
          .filter(_filter)
          .includeDeleted(false)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityCommunities.clear();
              amityCommunities.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            print(_controller.error.toString());
            print(_controller.stacktrace.toString());
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
      appBar: AppBar(title: const Text('Community List ')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              onChanged: (value) {
                _debouncer.run(() {
                  _keyboard = value;
                  _controller.reset();
                  _controller.fetchNextPage();
                });
              },
              decoration: const InputDecoration(hintText: 'Enter Keybaord'),
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text(AmityCommunityFilter.ALL.name),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text(AmityCommunityFilter.MEMBER.name),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text(AmityCommunityFilter.NOT_MEMBER.name),
                          value: 3,
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _filter = AmityCommunityFilter.ALL;
                      }
                      if (index == 2) {
                        _filter = AmityCommunityFilter.MEMBER;
                      }
                      if (index == 3) {
                        _filter = AmityCommunityFilter.NOT_MEMBER;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child:
                              Text(AmityCommunitySortOption.DISPLAY_NAME.name),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child:
                              Text(AmityCommunitySortOption.FIRST_CREATED.name),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child:
                              Text(AmityCommunitySortOption.LAST_CREATED.name),
                          value: 3,
                        )
                      ];
                    },
                    child: const Icon(
                      Icons.sort_rounded,
                      size: 18,
                    ),
                    onSelected: (index) {
                      if (index == 1) {
                        _sort = AmityCommunitySortOption.DISPLAY_NAME;
                      }
                      if (index == 2) {
                        _sort = AmityCommunitySortOption.FIRST_CREATED;
                      }
                      if (index == 3) {
                        _sort = AmityCommunitySortOption.LAST_CREATED;
                      }

                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: amityCommunities.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: amityCommunities.length,
                      itemBuilder: (context, index) {
                        final amityCommunity = amityCommunities[index];
                        return Container(
                          margin: const EdgeInsets.all(12),
                          child: CommunityWidget(
                            amityCommunity: amityCommunity,
                            // onCommentCallback: () {
                            //   // GoRouter.of(context).goNamed('commentCommunityFeed',
                            //   //     params: {'postId': amityPost.postId!});
                            // },
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_controller.isFetching && amityCommunities.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(AppRoute.createCommunity);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
