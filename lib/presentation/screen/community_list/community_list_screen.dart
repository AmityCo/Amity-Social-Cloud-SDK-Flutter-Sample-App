import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/utils/debouncer.dart';
import 'package:flutter_social_sample_app/core/widget/community_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:go_router/go_router.dart';

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  // var amityCommunities = <AmityCommunity>[];
  final List<AmityCommunity> _amityCommunities = [];
  final List<AmityCommunity> _amityCommunitiesForFeed = [];

  final scrollcontroller = ScrollController();
  bool loading = false;

  String _keyboard = '';

  final _debouncer = Debouncer(milliseconds: 500);

  AmityCommunityFilter _filter = AmityCommunityFilter.MEMBER;
  AmityCommunitySortOption _sort = AmityCommunitySortOption.LAST_CREATED;
  List<String>? _tags;

  bool _includeDelete = true;

  late CommunityLiveCollection communityLiveCollection;

  @override
  void initState() {

    communityLiveCollectionInit();
    initMyCommunity();
    super.initState();
  }

    void communityLiveCollectionInit() {

    communityLiveCollection = CommunityLiveCollection(
        request: () => AmitySocialClient.newCommunityRepository()
            .getCommunities()
            .withKeyword(_keyboard.isEmpty ? null : _keyboard)
            .sortBy(_sort)
            .filter(_filter)
            .tags(_tags ?? [])
            .includeDeleted(_includeDelete)
            .build());


    // communityLiveCollection.getStreamController().stream.listen((event) {
    //   if (mounted) {
    //     setState(() {
    //       amityCommunities = event;
    //     });
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      communityLiveCollection.loadNext();
    });

    scrollcontroller.addListener(pagination);
  }

  Future<void> initMyCommunity([String? keyword]) async {
    final repository = AmitySocialClient.newCommunityRepository()
        .getCommunities()
        .filter(AmityCommunityFilter.MEMBER)
        .includeDeleted(false);
    if (keyword != null && keyword.isNotEmpty) {
      repository.withKeyword(
          keyword); // Add keyword filtering only if keyword is provided and not empty
    }
    communityLiveCollection = repository.getLiveCollection(pageSize: 20);
    communityLiveCollection.getStreamController().stream.listen((event) {
      print("getStreamController");
      _amityCommunitiesForFeed.clear();
      _amityCommunitiesForFeed.addAll(event);

      _amityCommunities.clear();
      _amityCommunities.addAll(event);

      setState(() {
        
      });

    }).onError((error, stackTrace) {
      log("error:${error.error.toString()}");
      // await AmityDialog().showAlertErrorDialog(
      //     title: "Error!",
      //     message: _communityController.error.toString());
    });

    scrollcontroller.removeListener(() {});
    scrollcontroller.addListener(pagination);
  }

  void pagination() {
    if ((scrollcontroller.position.pixels ==
              scrollcontroller.position.maxScrollExtent) &&
          communityLiveCollection.hasNextPage()) {
        communityLiveCollection.loadNext();
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
                  communityLiveCollection.reset();
                  communityLiveCollectionInit();
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
                          value: 1,
                          child: Text(AmityCommunityFilter.ALL.name),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(AmityCommunityFilter.MEMBER.name),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Text(AmityCommunityFilter.NOT_MEMBER.name),
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
                      
                  communityLiveCollection.reset();
                  communityLiveCollectionInit();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(

                          child: Text(AmityCommunitySortOption.DISPLAY_NAME.name),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text(AmityCommunitySortOption.FIRST_CREATED.name),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text(AmityCommunitySortOption.LAST_CREATED.name),
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
                  communityLiveCollection.reset();
                  communityLiveCollectionInit();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    child: const Icon(Icons.tag, size: 18),
                    onTap: () {
                      EditTextDialog.show(context, title: 'Enter tags, separate by comma', hintText: 'type tags here',
                          onPress: (value) {
                        if (value.isNotEmpty) {
                          _tags = value.trim().split(',');
                        } else {
                          _tags = null;
                        }
                        communityLiveCollection.reset();
                        communityLiveCollectionInit();
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _includeDelete,
                        onChanged: (value) {
                          setState(() {
                            _includeDelete = (value ?? false);
                            communityLiveCollection.reset();

                            communityLiveCollectionInit();
                          });
                        },
                      ),
                      const Text('Include Delete')
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _amityCommunities.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      communityLiveCollection.reset();
                      communityLiveCollectionInit();
                    },
                    child: ListView.builder(
                      controller: scrollcontroller,
                      itemCount: _amityCommunities.length,
                      itemBuilder: (context, index) {
                        final amityCommunity = _amityCommunities[index];
                        return Container(
                          margin: const EdgeInsets.all(12),
                          child: CommunityWidget(
                            key: ValueKey(amityCommunity.communityId),
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
                    child: communityLiveCollection.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No Post'),
                  ),
          ),
          if (_amityCommunities.isNotEmpty && communityLiveCollection.isFetching)
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
