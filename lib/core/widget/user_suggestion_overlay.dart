import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';

class UserSuggesionOverlay {
  static final UserSuggesionOverlay _instance =
      UserSuggesionOverlay._internal();

  static UserSuggesionOverlay get instance => _instance;

  UserSuggesionOverlay._internal();

  void updateOverLay(
      BuildContext context,
      UserSuggestionType type,
      GlobalKey anchore,
      String value,
      Function(String keyword, AmityUser user) onUserSelect,
      {String? communityId,
      UserSuggestionPostion postion = UserSuggestionPostion.top}) {
    final regex = RegExp(r"\@[\w\-\_\.]*$");
    if (regex.hasMatch(value)) {
      final match = regex.allMatches(value).last;
      // if (match.group(0)!.replaceAll('@', '').length > 2) {
      _showOverlaidTag(context, type, anchore, value,
          match.group(0)!.replaceAll('@', ''), match.start, onUserSelect,
          communityId: communityId, postion: postion);
      // }
    }
  }

  void hideOverLay() {
    if (suggestionTagoverlayEntry != null) {
      suggestionTagoverlayEntry!.remove();
      suggestionTagoverlayEntry = null;
    }
  }

  OverlayEntry? suggestionTagoverlayEntry;
  _showOverlaidTag(
      BuildContext context,
      UserSuggestionType type,
      GlobalKey anchore,
      String newText,
      String keyword,
      int startIndex,
      Function(String keyword, AmityUser user) onUserSelect,
      {String? communityId,
      required UserSuggestionPostion postion}) async {
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: newText,
      ),
    );
    painter.layout();
    final width = MediaQuery.of(context).size.width;
    final overlayState = Overlay.of(context);

    final renderBox = anchore.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    double left = position.dx;
    double top = position.dy;

    if (postion == UserSuggestionPostion.top) {
      left = position.dx;
      top = position.dy - 200;
    } else {
      left = position.dx;
      top = position.dy + 60;
    }
    if (suggestionTagoverlayEntry == null) {
      suggestionTagoverlayEntry = OverlayEntry(builder: (context) {
        return Positioned(
          left: left,
          top: top,
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: type == UserSuggestionType.global
                        ? _GlobalUserSuggestionWidget(
                            keyword: keyword,
                            onUserSelect: (value) {
                              hideOverLay();
                              onUserSelect(keyword, value);
                            },
                          )
                        : _CommunityUserSuggestionWidget(
                            communityId: communityId!,
                            keyword: keyword,
                            onUserSelect: (value) {
                              hideOverLay();
                              onUserSelect(keyword, value);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
      overlayState.insert(suggestionTagoverlayEntry!);
    }
  }
}

class _GlobalUserSuggestionWidget extends StatefulWidget {
  const _GlobalUserSuggestionWidget(
      {Key? key, required this.keyword, required this.onUserSelect})
      : super(key: key);
  final String keyword;
  final ValueChanged<AmityUser> onUserSelect;

  @override
  State<_GlobalUserSuggestionWidget> createState() =>
      _GlobalUserSuggestionWidgetState();
}

class _GlobalUserSuggestionWidgetState
    extends State<_GlobalUserSuggestionWidget> {
  late PagingController<AmityUser> _controller;
  final amityUsers = <AmityUser>[];

  final scrollcontroller = ScrollController();

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmityCoreClient.newUserRepository()
          .searchUserByDisplayName(widget.keyword)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityUsers.clear();
              amityUsers.addAll(_controller.loadedItems);
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
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: amityUsers.isNotEmpty
                ? ListView.builder(
                    controller: scrollcontroller,
                    itemCount: amityUsers.length,
                    itemBuilder: (context, index) {
                      final amityUser = amityUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          foregroundImage:
                              NetworkImage(amityUser.avatarUrl ?? ''),
                        ),
                        title: Text(amityUser.userId!),
                        dense: true,
                        onTap: () {
                          widget.onUserSelect(amityUser);
                        },
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No User'),
                  ),
          ),
          if (_controller.isFetching && amityUsers.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

class _CommunityUserSuggestionWidget extends StatefulWidget {
  const _CommunityUserSuggestionWidget(
      {Key? key,
      required this.communityId,
      required this.keyword,
      required this.onUserSelect})
      : super(key: key);
  final String communityId;
  final String keyword;
  final ValueChanged<AmityUser> onUserSelect;

  @override
  State<_CommunityUserSuggestionWidget> createState() =>
      _CommunityUserSuggestionWidgetState();
}

class _CommunityUserSuggestionWidgetState
    extends State<_CommunityUserSuggestionWidget> {
  late PagingController<AmityCommunityMember> _controller;
  final amityCommunityMember = <AmityCommunityMember>[];

  final scrollcontroller = ScrollController();

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommunityRepository()
          .membership(widget.communityId)
          .searchMembers(widget.keyword)
          .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amityCommunityMember.clear();
              amityCommunityMember.addAll(_controller.loadedItems);
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
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: amityCommunityMember.isNotEmpty
                ? ListView.builder(
                    controller: scrollcontroller,
                    itemCount: amityCommunityMember.length,
                    itemBuilder: (context, index) {
                      final amityCommunityUser = amityCommunityMember[index];
                      return ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(
                              amityCommunityUser.user?.avatarUrl ?? ''),
                        ),
                        title: Text(amityCommunityUser.user!.userId!),
                        dense: true,
                        onTap: () {
                          widget.onUserSelect(amityCommunityUser.user!);
                        },
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: _controller.isFetching
                        ? const CircularProgressIndicator()
                        : const Text('No User'),
                  ),
          ),
          if (_controller.isFetching && amityCommunityMember.isNotEmpty)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

enum UserSuggestionType { global, community, channel }

enum UserSuggestionPostion { top, bottom }
