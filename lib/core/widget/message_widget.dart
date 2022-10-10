import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_downloader/image_downloader.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({Key? key, required this.message}) : super(key: key);
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

    // if (value.messageId == '631882bd09045c4fc8281a57') print(value.toString());

    if (value.reactions!.reactions != null &&
        value.reactions!.reactions!.isNotEmpty) {
      value.reactions!.reactions!.removeWhere((key, value) => value == 0);
    }

    AmityMessageData? data = value.data;
    if (data != null) {
      if (data is MessageTextData) text = data.text!;
    } else {
      _notSupportedDataType = true;
    }

    if (value.isDeleted ?? false) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_rounded),
            const SizedBox(width: 12),
            Text(
              'Message has been deleted',
              style: _themeData.textTheme.caption,
            )
          ],
        ),
      );
    }

    return InkWell(
      onLongPress: () {
        _reactionDialog(context, message);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)
              ],
            ),
            // color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.3)),
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
                      Text(
                        _user.displayName!,
                        style: _themeData.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _notSupportedDataType
                          ? Text(
                              'DataType Not Supported : ${message.type?.value}',
                              style: _themeData.textTheme.bodyText2!.copyWith(),
                            )
                          : _getContentWidget(context, data!),
                      // const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            value.createdAt?.toLocal().toIso8601String() ??
                                DateTime.now().toLocal().toIso8601String(),
                            style: _themeData.textTheme.caption!.copyWith(),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            value.syncState!.value.toUpperCase(),
                            style: _themeData.textTheme.caption!.copyWith(),
                          ),
                        ],
                      ),
                      Text(
                        'My Reaction - ${value.myReactions?.join(',') ?? ' Null'}',
                        style: _themeData.textTheme.caption!.copyWith(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // if (_isLikedByMe)
          if (value.reactions!.reactions != null &&
              value.reactions!.reactions!.isNotEmpty)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  // color: Colors.red,
                  child: InkWell(
                    onLongPress: () {
                      GoRouter.of(context).pushNamed(AppRoute.messageReaction,
                          params: {'messageId': message.messageId!});
                    },
                    child: Stack(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        if (value.reactions!.getCount('like') > 0)
                          Container(
                            // width: 36,
                            // height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('like')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      value.reactions!
                                          .getCount('like')
                                          .toString(),
                                      style: _themeData.textTheme.caption!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    'assets/ic_liked.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('Like') > 0)
                          Container(
                            // width: 36,
                            // height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('like')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      value.reactions!
                                          .getCount('like')
                                          .toString(),
                                      style: _themeData.textTheme.caption!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    'assets/ic_liked.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('love') > 0)
                          Container(
                            // width: 36,
                            // height: 36,
                            margin: const EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('love')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Text(
                                    value.reactions!
                                        .getCount('love')
                                        .toString(),
                                    style: _themeData.textTheme.caption!
                                        .copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    'assets/ic_heart.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('Love') > 0)
                          Container(
                            // width: 36,
                            // height: 36,
                            margin: const EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('love')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Text(
                                    value.reactions!
                                        .getCount('love')
                                        .toString(),
                                    style: _themeData.textTheme.caption!
                                        .copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    'assets/ic_heart.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _getContentWidget(BuildContext context, AmityMessageData data) {
    final _themeData = Theme.of(context);

    if (data is MessageTextData) {
      return Text(
        data.text!,
        style: _themeData.textTheme.bodyText2!.copyWith(),
      );
    }

    if (data is MessageImageData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Colors.red,
            child: SizedBox(
              width: 100,
              height: 100,
              child: data.image.hasLocalPreview
                  ? Image.file(
                      File(data.image.getFilePath!),
                      fit: BoxFit.cover,
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            data.image.getUrl(AmityImageSize.MEDIUM),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(.3)),
                            child: InkWell(
                              child: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                var imageId =
                                    await ImageDownloader.downloadImage(data
                                        .image
                                        .getUrl(AmityImageSize.MEDIUM));
                                if (imageId == null) {
                                  return;
                                }

                                // Below is a method of obtaining saved image information.
                                var fileName =
                                    await ImageDownloader.findName(imageId);
                                var path =
                                    await ImageDownloader.findPath(imageId);

                                print(fileName);
                                print(path);

                                CommonSnackbar.showPositiveSnackbar(
                                    context, 'Success', 'Image Save $fileName');

                                // await GallerySaver.saveImage(path!).then(
                                //   (value) {
                                //     CommonSnackbar.showPositiveSnackbar(context,
                                //         'Success', 'Image Saved in Gallary');
                                //   },
                                // ).onError((error, stackTrace) {
                                //   CommonSnackbar.showNagativeSnackbar(
                                //       context, 'Error', error.toString());
                                // });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          if (data.caption != null && data.caption!.isNotEmpty)
            Text(
              '${data.caption}',
              style: _themeData.textTheme.bodyText2,
            ),
        ],
      );
    }

    if (data is MessageFileData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.file.hasLocalPreview
              ? TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file_rounded),
                  label: Text(
                    data.file.getFilePath!.split('/').last,
                  ),
                )
              : Container(
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: const Icon(Icons.attach_file_rounded),
                    title: Text(
                      data.file.fileName,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.3)),
                      child: InkWell(
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          var fileId = await ImageDownloader.downloadImage(
                              data.file.getUrl);
                          if (fileId == null) {
                            return;
                          }

                          // Below is a method of obtaining saved image information.
                          var fileName = await ImageDownloader.findName(fileId);
                          var path = await ImageDownloader.findPath(fileId);

                          print(fileName);
                          print(path);
                        },
                      ),
                    ),
                    // tileColor: Colors.red,
                    // focusColor: Colors.red,
                    // selectedColor: Colors.red,
                  ),
                ),
          // TextButton.icon(
          //     onPressed: () {},
          //     icon: const Icon(Icons.attach_file_rounded),
          //     label: Text(
          //       data.file.getUrl.split('/').last,
          //     ),
          //     style: TextButton.styleFrom(
          //       padding: const EdgeInsets.all(12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       primary: Colors.black,
          //       backgroundColor: Colors.grey.shade300,
          //     ),
          //   ),
          if (data.caption != null && data.caption!.isNotEmpty)
            Text(
              '${data.caption}',
              style: _themeData.textTheme.bodyText2,
            ),
        ],
      );
    }

    return Text(
      'Still not supported',
      style: _themeData.textTheme.bodyText2!.copyWith(),
    );
  }

  void _reactionDialog(BuildContext context, AmityMessage message) {
    final myReaction = message.myReactions ?? [];
    showDialog(
      context: context,
      builder: (innercontext) {
        return AlertDialog(
          title: const Text('Reaction'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (myReaction.contains('like')) {
                        CommonSnackbar.showNagativeSnackbar(context, 'Error',
                            'You already have like reaction on this message');
                      } else {
                        Navigator.of(context).pop();
                        message.react().addReaction('like').then((value) {
                          CommonSnackbar.showPositiveSnackbar(context,
                              'Success', 'Reaction Added Successfully - like');
                        }).onError(
                          (error, stackTrace) {
                            CommonSnackbar.showNagativeSnackbar(context, 'Fail',
                                'Reaction Added Failed ${error.toString()} - like');
                          },
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/ic_liked.png',
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (myReaction.contains('love')) {
                        CommonSnackbar.showNagativeSnackbar(context, 'Error',
                            'You already have love reaction on this message');
                      } else {
                        Navigator.of(context).pop();
                        message.react().addReaction('love').then((value) {
                          CommonSnackbar.showPositiveSnackbar(context,
                              'Success', 'Reaction Added Successfully - love');
                        }).onError(
                          (error, stackTrace) {
                            CommonSnackbar.showNagativeSnackbar(context, 'Fail',
                                'Reaction Added Failed ${error.toString()} - love');
                          },
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/ic_heart.png',
                      height: 18,
                      width: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
