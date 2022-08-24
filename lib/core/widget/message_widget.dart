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
}
