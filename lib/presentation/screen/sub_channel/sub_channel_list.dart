import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_social_sample_app/core/constant/global_constant.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/subchannel_item_widget.dart';
import 'package:go_router/go_router.dart';

class SubChannelList extends StatefulWidget {
  final String channelId;
  const SubChannelList({super.key, required this.channelId});

  @override
  State<SubChannelList> createState() => _SubChannelListState();
}

class _SubChannelListState extends State<SubChannelList> {
  late PagingController<AmitySubChannel> _controller;
  final amitySubChannels = <AmitySubChannel>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  @override
  void initState() {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newSubChannelRepository()
      .getSubchannel()
      .channelId(widget.channelId)
      .excludeMainSubChannel(true)
      .includeDeleted(true)
      .getPagingData(token: token, limit: GlobalConstant.pageSize),
      pageSize: GlobalConstant.pageSize,
    )..addListener(
        () {
          if (_controller.error == null) {
            setState(() {
              amitySubChannels.clear();
              amitySubChannels.addAll(_controller.loadedItems);
            });
          } else {
            //Error on pagination controller
            setState(() {});
            print(_controller.stacktrace);
            ErrorDialog.show(context, title: 'Error', message: '${_controller.error}\n${_controller.stacktrace}');
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
    if ((scrollcontroller.position.pixels == scrollcontroller.position.maxScrollExtent) && _controller.hasMoreItems) {
      setState(() {
        _controller.fetchNextPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: amitySubChannels.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        _controller.reset();
                        _controller.fetchNextPage();
                      },
                      child: ListView.builder(
                        controller: scrollcontroller,
                        itemCount: amitySubChannels.length,
                        itemBuilder: (context, index) {
                          final amitySubChannel = amitySubChannels[index];
                          var uniqueKey = UniqueKey();
                          return SubChannelItemWidget( key: uniqueKey , subChannel: amitySubChannel);
                          
                          // ListTile(
                          //   onTap: () {
                          //     GoRouter.of(context).pushNamed(AppRoute.chat, params: {
                          //       'channelId': amitySubChannel.subChannelId!,
                          //       'channelName': amitySubChannel.displayName!,
                          //     });
                          //   },
                          //   key: uniqueKey,
                          //   title: Text("${amitySubChannel.displayName}"),
                          // );
                        },
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: _controller.isFetching ? const CircularProgressIndicator() : const Text('No Global Post'),
                    ),
            ),
            if (_controller.isFetching && amitySubChannels.isNotEmpty)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
          ],
        ));
  }
}
