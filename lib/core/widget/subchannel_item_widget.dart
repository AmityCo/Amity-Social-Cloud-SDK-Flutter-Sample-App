import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/edit_text_dialog.dart';
import 'package:go_router/go_router.dart';

class SubChannelItemWidget extends StatelessWidget {
  final AmitySubChannel subChannel;
  const SubChannelItemWidget({super.key, required this.subChannel});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed(AppRoute.chat, params: {
            'channelId': subChannel.subChannelId!,
            'channelName': subChannel.displayName!,
          });
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subChannel.displayName ?? '<< No display name >>',
                          style: themeData.textTheme.titleLarge,
                        ),
                        PopupMenuButton(
                            child: const Icon(Icons.arrow_drop_down_circle_outlined),
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: 0,
                                  child: Text('Soft Delete'),
                                ),
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text('Hard Delete'),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text('Edit SubChannel'),
                                ),
                                const PopupMenuItem(
                                  value: 3,
                                  child: Text('Subscribe to RTE'),
                                ),
                                const PopupMenuItem(
                                  value: 4,
                                  child: Text('UnSubscribe to RTE'),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              switch (value) {
                                case 0:
                                  AmitySocialClient.newSubChannelRepository()
                                      .softDeleteSubChannel(subChannelId: subChannel.subChannelId!)
                                      .then(
                                        (value) => (context.mounted)
                                            ? CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'SubChannel Soft Deleted',
                                              )
                                            : null,
                                      )
                                      .onError(
                                        (error, stackTrace) => (context.mounted)
                                            ? CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString(),
                                              )
                                            : null,
                                      );
                                  break;
                                case 1:
                                  AmitySocialClient.newSubChannelRepository()
                                      .hardDeleteSubChannel(subChannelId: subChannel.subChannelId!)
                                      .then(
                                        (value) => (context.mounted)
                                            ? CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'SubChannel Hard Deleted',
                                              )
                                            : null,
                                      )
                                      .onError(
                                        (error, stackTrace) => (context.mounted)
                                            ? CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString(),
                                              )
                                            : null,
                                      );
                                  break;
                                case 2:
                                  EditTextDialog.show(
                                    context,
                                    hintText: 'Enter new Display Name',
                                    onPress: (value) {
                                      AmitySocialClient.newSubChannelRepository()
                                          .updateeditSubChannelSubChannel(
                                            subChannelId: subChannel.subChannelId!,
                                            displayName: value,
                                          )
                                          .then((value) => (context.mounted) ? CommonSnackbar.showPositiveSnackbar(context, 'Success', 'SubChannel Updated') : null)
                                          .onError((error, stackTrace) => (context.mounted) ? CommonSnackbar.showNagativeSnackbar(context, 'Error', error.toString()) : null);
                                    },
                                  );
                                  break;

                                case 3:
                                  subChannel
                                      .subscription()
                                      .subscribeTopic()
                                      .then(
                                        (value) => (context.mounted)
                                            ? CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'SubChannel Subscribed',
                                              )
                                            : null,
                                      )
                                      .onError(
                                        (error, stackTrace) => (context.mounted)
                                            ? CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString(),
                                              )
                                            : null,
                                      );
                                  break;
                                case 4:
                                  subChannel
                                      .subscription()
                                      .unsubscribeTopic()
                                      .then(
                                        (value) => (context.mounted)
                                            ? CommonSnackbar.showPositiveSnackbar(
                                                context,
                                                'Success',
                                                'SubChannel Unsubscribed',
                                              )
                                            : null,
                                      )
                                      .onError(
                                        (error, stackTrace) => (context.mounted)
                                            ? CommonSnackbar.showNagativeSnackbar(
                                                context,
                                                'Error',
                                                error.toString(),
                                              )
                                            : null,
                                      );
                                  break;
                              }
                            }),
                      ],
                    ),
                    Text(
                      'Message Count: ${subChannel.messageCount ?? 'NaN'}',
                      style: themeData.textTheme.bodySmall,
                    ),
                    Text(
                      'isDeleted: ${subChannel.isDeleted ?? 'NaN'}',
                      style: themeData.textTheme.bodySmall,
                    ),
                    Text(
                      'last Activity: ${subChannel.lastActivity?.toIso8601String() ?? 'NaN'}',
                      style: themeData.textTheme.bodySmall,
                    ),
                    Text(
                      'isDeleted: ${subChannel.isDeleted ?? 'NaN'}',
                      style: themeData.textTheme.bodySmall,
                    ),
                    SelectableText(
                      'SubChannel ID : ${subChannel.subChannelId ?? 'NaN'}',
                      style: themeData.textTheme.bodySmall,
                    ),
                  ],
                ),
                subChannel.isDeleted ?? false
                    ? Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: Colors.red,
                          child: Text(
                            'Deleted',
                            style: themeData.textTheme.titleLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
