import 'dart:io';

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

    if (value.isDeleted ?? false) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                  textAlign: TextAlign.start,
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
                          : WidgetSpan(child: _getContentWidget(context, data!))
                    ],
                  ),
                ),
                const SizedBox(height: 6),
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
              ],
            ),
          ),
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
      return RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${data.caption ?? ''} \n',
            style: _themeData.textTheme.bodyText2,
          ),
          WidgetSpan(
              child: SizedBox(
            width: 100,
            height: 100,
            child: data.image.hasLocalPreview
                ? Image.file(
                    File(data.image.getFilePath!),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    data.image.getUrl(AmityImageSize.MEDIUM),
                    fit: BoxFit.cover,
                  ),
          ))
        ]),
      );
    }

    if (data is MessageFileData) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '${data.caption ?? ''} \n',
            style: _themeData.textTheme.bodyText2,
          ),
          WidgetSpan(
              child: data.file.hasLocalPreview
                  ? TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file_rounded),
                      label: Text(
                        data.file.getFilePath!.split('/').last,
                      ),
                    )
                  : TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file_rounded),
                      label: Text(
                        data.file.getUrl.split('/').last,
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.black,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ))
        ]),
      );
    }

    return Text(
      'Still not supported',
      style: _themeData.textTheme.bodyText2!.copyWith(),
    );
  }
}
