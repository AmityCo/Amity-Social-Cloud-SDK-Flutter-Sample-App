import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/subchannel_item_widget.dart';

class GetSubChannelScreen extends StatelessWidget {
  final String subChannelId;
  const GetSubChannelScreen({super.key, required this.subChannelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SubChannel -  $subChannelId'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<AmitySubChannel>(
          stream: AmitySocialClient.newSubChannelRepository().live.getSubChannel(subChannelId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final value = snapshot.data!;
              return SubChannelItemWidget(subChannel: value);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
