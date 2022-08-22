import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key? key, required this.message}) : super(key: key);
  final AmityMessage message;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getBody(context, message),
    );
  }

  Widget _getBody(BuildContext context, AmityMessage value) {
    final _themeData = Theme.of(context);
    AmityUser _user = value.user!;
    String text = '';
    bool _notSupportedDataType = false;

    bool _isLikedByMe = value.myReactions?.isNotEmpty ?? false;

    AmityMessageData? data = value.data;
    if (data != null) {
      if (data is MessageTextData) text = data.text!;
    } else {
      _notSupportedDataType = true;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      // decoration: BoxDecoration(color: Colors.red),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            child: _user.avatarUrl != null
                ? Image.network(
                    _user.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _user.displayName!,
                        style: _themeData.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      _notSupportedDataType
                          ? TextSpan(
                              text:
                                  'DataType Not Supported : ${message.type?.value}',
                              style: _themeData.textTheme.bodyText2!.copyWith(),
                            )
                          : TextSpan(
                              text: text,
                              style: _themeData.textTheme.bodyText2!.copyWith(),
                            )
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    // Text(
                    //   value.createdAt!.beforeTime(),
                    //   style: _themeData.textTheme.caption!.copyWith(),
                    // ),
                    // const SizedBox(width: 12),
                    // InkWell(
                    //   onTap: () {
                    //     if (_isLikedByMe) {
                    //       value.react().removeReaction('like');
                    //     } else {
                    //       value.react().addReaction('like');
                    //     }
                    //   },
                    //   onLongPress: () {
                    //     GoRouter.of(context).pushNamed(AppRoute.commentReaction,
                    //         params: {'commentId': value.commentId!});
                    //   },
                    //   child: Text(
                    //     '${value.reactionCount} Likes',
                    //     style: _themeData.textTheme.caption!.copyWith(),
                    //   ),
                    // ),
                    // const SizedBox(width: 12),
                    // InkWell(
                    //   onTap: () {
                    //     widget.onReply(value);
                    //   },
                    //   child: Text(
                    //     'Reply',
                    //     style: _themeData.textTheme.caption!.copyWith(),
                    //   ),
                    // ),
                    // const SizedBox(width: 12),
                    // InkWell(
                    //   onTap: () {
                    //     if (value.isFlaggedByMe) {
                    //       value
                    //           .report()
                    //           .unflag()
                    //           .then((value) =>
                    //               CommonSnackbar.showPositiveSnackbar(
                    //                   context, 'Success', 'UnFlag the Comment'))
                    //           .onError((error, stackTrace) =>
                    //               CommonSnackbar.showNagativeSnackbar(
                    //                   context, 'Error', error.toString()));
                    //     } else {
                    //       value
                    //           .report()
                    //           .flag()
                    //           .then((value) =>
                    //               CommonSnackbar.showPositiveSnackbar(
                    //                   context, 'Success', 'Flag the Comment'))
                    //           .onError((error, stackTrace) =>
                    //               CommonSnackbar.showNagativeSnackbar(
                    //                   context, 'Error', error.toString()));
                    //     }
                    //   },
                    //   child: Text(
                    //     '${value.flagCount} Flag',
                    //     style: _themeData.textTheme.caption!.copyWith(
                    //         fontWeight: value.isFlaggedByMe
                    //             ? FontWeight.bold
                    //             : FontWeight.normal),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
          // PopupMenuButton(
          //   itemBuilder: (context) {
          //     return [
          //       if (_user.userId == AmityCoreClient.getUserId())
          //         const PopupMenuItem(
          //           child: Text("Edit"),
          //           value: 1,
          //         ),
          //       if (_user.userId == AmityCoreClient.getUserId())
          //         const PopupMenuItem(
          //           child: Text("Delete (Soft)"),
          //           value: 2,
          //         ),
          //       if (_user.userId == AmityCoreClient.getUserId())
          //         const PopupMenuItem(
          //           child: Text("Delete (Hard)"),
          //           value: 3,
          //           enabled: false,
          //         ),
          //       PopupMenuItem(
          //         child: Text(value.isFlaggedByMe ? 'Unflagged' : 'Flag'),
          //         value: 4,
          //       ),
          //     ];
          //   },
          //   child: const Icon(
          //     Icons.more_vert_rounded,
          //     size: 18,
          //   ),
          //   onSelected: (index1) {
          //     if (index1 == 1) {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (context) => UpdateCommentScreen(
          //             amityComment: value,
          //           ),
          //         ),
          //       );
          //     }
          //     if (index1 == 2) {
          //       value.delete();
          //     }
          //     if (index1 == 4) {
          //       if (value.isFlaggedByMe) {
          //         value
          //             .report()
          //             .unflag()
          //             .then((value) => CommonSnackbar.showPositiveSnackbar(
          //                 context, 'Success', 'UnFlag the Comment'))
          //             .onError((error, stackTrace) =>
          //                 CommonSnackbar.showNagativeSnackbar(
          //                     context, 'Error', error.toString()));
          //       } else {
          //         value
          //             .report()
          //             .flag()
          //             .then((value) => CommonSnackbar.showPositiveSnackbar(
          //                 context, 'Success', 'Flag the Comment'))
          //             .onError((error, stackTrace) =>
          //                 CommonSnackbar.showNagativeSnackbar(
          //                     context, 'Error', error.toString()));
          //       }
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
