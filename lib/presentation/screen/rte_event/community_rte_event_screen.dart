import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/community_profile_info_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';
import 'package:flutter_social_sample_app/core/widget/text_check_box_widget.dart';

class CommunityRteEventScreen extends StatefulWidget {
  const CommunityRteEventScreen({super.key, required this.communityId});
  final String communityId;
  @override
  State<CommunityRteEventScreen> createState() => _CommunityRteEventScreenState();
}

class _CommunityRteEventScreenState extends State<CommunityRteEventScreen> {
  Future<AmityCommunity>? _future;
  final eventPool = <String, bool>{};
  AmityCommunity? amityCommunity;
  @override
  void initState() {
    _future = AmitySocialClient.newCommunityRepository().getCommunity(widget.communityId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community RTE'),
      ),
      body: FutureBuilder<AmityCommunity>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              amityCommunity = snapshot.data!;
              return ListView(
                children: [
                  ShadowContainerWidget(
                    child: Wrap(
                      children: [
                        ...List.generate(
                          AmityCommunityEvents.values.length,
                          (index) => TextCheckBox(
                            title: AmityCommunityEvents.values[index].name,
                            value: eventPool[AmityCommunityEvents.values[index].name] ?? false,
                            onChanged: (value) {
                              final completer = Completer();
                              ProgressDialog.showCompleter(context, completer);

                              eventPool[AmityCommunityEvents.values[index].name] = value ?? false;

                              if (eventPool[AmityCommunityEvents.values[index].name] ?? false) {
                                ///Subscribe to the event
                                amityCommunity!
                                    .subscription(AmityCommunityEvents.values[index])
                                    .subscribeTopic()
                                    .then((value) {
                                  completer.complete();
                                  CommonSnackbar.showPositiveSnackbar(
                                      context, 'Success', 'Subcribed to ${AmityCommunityEvents.values[index].name}');
                                }).onError((error, stackTrace) {
                                  completer.complete();
                                  CommonSnackbar.showNagativeSnackbar(context, 'Error',
                                      'Failed to subscribe to ${AmityCommunityEvents.values[index].name} $error');
                                });
                              } else {
                                ///Unsubscribe to the event
                                amityCommunity!
                                    .subscription(AmityCommunityEvents.values[index])
                                    .unsubscribeTopic()
                                    .then((value) {
                                  completer.complete();
                                  CommonSnackbar.showPositiveSnackbar(
                                      context, 'Success', 'Unsubcribed to ${AmityCommunityEvents.values[index].name}');
                                }).onError((error, stackTrace) {
                                  completer.complete();
                                  CommonSnackbar.showNagativeSnackbar(context, 'Error',
                                      'Failed to unsubscribe to ${AmityCommunityEvents.values[index].name} $error');
                                });
                              }
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<AmityCommunity>(
                      initialData: amityCommunity,
                      stream: amityCommunity!.listen.stream,
                      builder: (context, snapshot) {
                        return CommunityProfileInfoWidget(
                          key: UniqueKey(),
                          amityCommunity: snapshot.data!,
                        );
                      }),
                  FutureBuilder<List<AmityCommunityMember>>(
                    key: UniqueKey(),
                    future:
                        AmitySocialClient.newCommunityRepository().membership(widget.communityId).getMembers().query(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final members = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return CommunityMemberWidget(
                              amityCommunityMember: member,
                              onMemberCallback: () {},
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  @override
  void dispose() {
    amityCommunity!.subscription(AmityCommunityEvents.values[0]).unsubscribeTopic();
    amityCommunity!.subscription(AmityCommunityEvents.values[1]).unsubscribeTopic();
    amityCommunity!.subscription(AmityCommunityEvents.values[2]).unsubscribeTopic();
    amityCommunity!.subscription(AmityCommunityEvents.values[3]).unsubscribeTopic();
    super.dispose();
  }
}
