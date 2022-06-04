import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/community_catrgory_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:go_router/go_router.dart';

class CommunityCategoryListScreen extends StatefulWidget {
  const CommunityCategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityCategoryListScreen> createState() =>
      _CommunityCategoryListScreenState();
}

class _CommunityCategoryListScreenState
    extends State<CommunityCategoryListScreen> {
  late PagingController<AmityCommunityCategory> _controller;
  final amityCommunityCategories = <AmityCommunityCategory>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityCommunityCategorySortOption _sort =
      AmityCommunityCategorySortOption.NAME;

  List<AmityCommunityCategory> selectedCategory = [];

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .getCategories()
          // .withKeyword(_keyboard.isEmpty ? null : _keyboard)
          .sortBy(_sort)
          // .filter(_filter)
          .includeDeleted(false)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityCommunityCategories.clear();
              amityCommunityCategories.addAll(_controller.loadedItems);
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child:
                              Text(AmityCommunityCategorySortOption.NAME.name),
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
                        _sort = AmityCommunityCategorySortOption.NAME;
                      }
                      if (index == 2) {
                        _sort = AmityCommunityCategorySortOption.FIRST_CREATED;
                      }
                      if (index == 3) {
                        _sort = AmityCommunityCategorySortOption.LAST_CREATED;
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
            child: amityCommunityCategories.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      _controller.reset();
                      _controller.fetchNextPage();
                    },
                    child: Container(
                      child: ListView.builder(
                        controller: scrollcontroller,
                        itemCount: amityCommunityCategories.length,
                        padding: const EdgeInsets.only(bottom: 58),
                        itemBuilder: (context, index) {
                          final amityCommunityCategory =
                              amityCommunityCategories[index];
                          return Container(
                            margin: const EdgeInsets.all(12),
                            child: CommunityCategoryWidget(
                                amityCommunityCategory: amityCommunityCategory,
                                valueChanged: (value) {
                                  if (value) {
                                    selectedCategory
                                        .add(amityCommunityCategory);
                                  } else {
                                    selectedCategory
                                        .remove(amityCommunityCategory);
                                  }
                                }),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_controller.isFetching && amityCommunityCategories.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(
            AppRoute.createCommunity,
            queryParams: {
              'categoryIds':
                  selectedCategory.map((e) => e.categoryId).join(','),
            },
          );
        },
        child: const Icon(Icons.check_sharp),
      ),
    );
  }
}
