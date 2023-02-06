import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class UserSuggesionOverlay {
  static final UserSuggesionOverlay _instance =
      UserSuggesionOverlay._internal();

  static UserSuggesionOverlay get instance => _instance;
  // factory Singleton() {
  //   return _singleton;
  // }

  UserSuggesionOverlay._internal();
  void updateOverLay(BuildContext context, GlobalKey anchore, String value,
      Function(String keyword, AmityUser user) onUserSelect) {
    final regex = RegExp(r"\@[\w\-\_\.]*$");
    if (regex.hasMatch(value)) {
      final match = regex.allMatches(value).last;
      _showOverlaidTag(context, anchore, value,
          match.group(0)!.replaceAll('@', ''), match.start, onUserSelect);
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
      GlobalKey anchore,
      String newText,
      String keyword,
      int startIndex,
      Function(String keyword, AmityUser user) onUserSelect) async {
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

    final left = position.dx;
    final top = position.dy - 200;

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
                    child: _GlobalUserSuggestionWidget(
                      keyword: keyword,
                      onUserSelect: (value) {
                        hideOverLay();
                        onUserSelect(keyword, value);

                        // _commentTextEditController.text =
                        //     _commentTextEditController.text
                        //         .trim()
                        //         .replaceAll(keyword, '');

                        // _amityMentionMetadata ??= [];
                        // if (value.amityMentionType ==
                        //     AmityMentionType.CHANNEL) {
                        //   _amityMentionMetadata!.add(
                        //     MentionData(AmityMentionType.CHANNEL.value,
                        //         startIndex, 'all'.length,
                        //         displayName: 'all'),
                        //   );
                        //   _commentTextEditController.text =
                        //       '${_commentTextEditController.text.trim()}all';
                        // } else {
                        //   _amityMentionMetadata!.add(
                        //     MentionData(
                        //       AmityMentionType.USER.value,
                        //       startIndex,
                        //       value.amityChannelMember!.user!.displayName!
                        //           .length,
                        //       userId: value.amityChannelMember!.userId!,
                        //       displayName:
                        //           value.amityChannelMember!.user!.displayName!,
                        //     ),
                        //   );
                        //   _commentTextEditController.text =
                        //       '${_commentTextEditController.text.trim()}${value.amityChannelMember!.user!.displayName}';
                        // }

                        // _commentTextEditController.selection =
                        //     TextSelection.fromPosition(TextPosition(
                        //         offset:
                        //             _commentTextEditController.text.length));
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

class _GlobalUserSuggestionWidget extends StatelessWidget {
  const _GlobalUserSuggestionWidget(
      {Key? key, required this.keyword, required this.onUserSelect})
      : super(key: key);
  final String keyword;
  final ValueChanged<AmityUser> onUserSelect;
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
      child: FutureBuilder<List<AmityUser>>(
        future: AmityCoreClient.newUserRepository()
            .searchUserByDisplayName(keyword)
            .query(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                // ListTile(
                //   leading: const CircleAvatar(
                //     foregroundImage: NetworkImage(''),
                //   ),
                //   title: const Text('All'),
                //   dense: true,
                //   onTap: () {
                //     // onUserSelect(
                //     //     ChannelMemberTagData(AmityMentionType.CHANNEL));
                //   },
                // ),
                ...List.generate(
                  snapshot.data!.length,
                  (index) {
                    final amityUser = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage:
                            NetworkImage(amityUser.avatarUrl ?? ''),
                      ),
                      title: Text(amityUser.userId!),
                      dense: true,
                      onTap: () {
                        onUserSelect(amityUser);
                      },
                    );
                  },
                )
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
