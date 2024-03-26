import 'dart:async';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:flutter_social_sample_app/core/widget/community_member_widget.dart';
import 'package:flutter_social_sample_app/core/widget/community_profile_info_widget.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/progress_dialog_widget.dart';
import 'package:flutter_social_sample_app/core/widget/shadow_container_widget.dart';

class CommunityRteEventScreen extends StatefulWidget {
  const CommunityRteEventScreen({super.key, required this.communityId});
  final String communityId;
  @override
  State<CommunityRteEventScreen> createState() => _CommunityRteEventScreenState();
}

class _CommunityRteEventScreenState extends State<CommunityRteEventScreen> {
  late Future<List<AmityCommunityMember>> _membersFuture;

  final eventPool = <String, bool>{};
  AmityCommunity? amityCommunity;
  @override
  void initState() {
    fetchCommunityMembers();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community RTE'),
      ),
      body: StreamBuilder<AmityCommunity>(
        stream: AmitySocialClient.newCommunityRepository()
          .live
          .getCommunity(widget.communityId),
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
                            (index) => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AmityCommunityEvents.values[index].name
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final completer = Completer();
                                    ProgressDialog.showCompleter(
                                        context, completer);

                                    amityCommunity!
                                        .subscription(
                                            AmityCommunityEvents.values[index])
                                        .subscribeTopic()
                                        .then((value) {
                                      completer.complete();
                                      CommonSnackbar.showPositiveSnackbar(
                                          context,
                                          'Success',
                                          'Subscribed to ${AmityCommunityEvents.values[index].name}');
                                      setState(() {});
                                    }).onError((error, stackTrace) {
                                      completer.complete();
                                      CommonSnackbar.showNagativeSnackbar(
                                          context,
                                          'Error',
                                          'Failed to subscribe to ${AmityCommunityEvents.values[index].name} $error');
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.zero),
                                  ),
                                  child: const SizedBox(
                                    child: Center(
                                      child: Text(
                                        'Sub'
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final completer = Completer();
                                    ProgressDialog.showCompleter(
                                        context, completer);

                                    amityCommunity!
                                        .subscription(
                                            AmityCommunityEvents.values[index])
                                        .unsubscribeTopic()
                                        .then((value) {
                                      completer.complete();
                                      CommonSnackbar.showPositiveSnackbar(
                                          context,
                                          'Success',
                                          'Unsubscribed to ${AmityCommunityEvents.values[index].name}');
                                      setState(() {});
                                    }).onError((error, stackTrace) {
                                      completer.complete();
                                      CommonSnackbar.showNagativeSnackbar(
                                          context,
                                          'Error',
                                          'Failed to unsubscribe to ${AmityCommunityEvents.values[index].name} $error');
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.zero),
                                  ),
                                  child: const SizedBox(
                                    child: Center(
                                      child: Text(
                                        'Unsub'
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                  ElevatedButton(
                    onPressed: () {
                      fetchCommunityMembers();
                    },
                    child: const Text('Fetch Members'),
                  ),
                  FutureBuilder<List<AmityCommunityMember>>(
                    key: UniqueKey(),
                    future:
                        _membersFuture,
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
          })
          );
          
  }

  void fetchCommunityMembers() {
    _membersFuture = AmitySocialClient.newCommunityRepository()
        .membership(widget.communityId)
        .getMembers()
        .query();
  }
}
