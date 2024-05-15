import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';

class CommunityNotificationSettingsScreen extends StatefulWidget {
  final String communityId;
  const CommunityNotificationSettingsScreen(
      {super.key, required this.communityId});

  @override
  State<CommunityNotificationSettingsScreen> createState() =>
      _CommunityNotificationSettingsScreenState();
}

class _CommunityNotificationSettingsScreenState
    extends State<CommunityNotificationSettingsScreen> {
  late Future<AmityCommunityNotificationSettings> _future;

  AmityCommunityNotificationSettings? currentSettings;

  AmityRoles modRoles =
      AmityRoles(roles: ["channel-moderator", "community-moderator"]);

  bool isloading = false;

  @override
  void initState() {
    _future = AmityCoreClient()
        .notifications()
        .community(widget.communityId)
        .getSettings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Notification Settings')),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              print("snapshot.data: ${snapshot.data!.events ?? "No Data"}");

              if (snapshot.data != null) {
                currentSettings = snapshot.data;

                return Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Enable Notification"),
                        trailing: Switch(
                          value: currentSettings!.isEnabled ?? false,
                          onChanged: (value) {
                            setState(() {
                              currentSettings!.isEnabled = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentSettings!.events!.length,
                          itemBuilder: (context, index) {
                            var currentEvent = currentSettings!.events![index];
                            var fliterSelected = "";

                            if (currentEvent.rolesFilter is All) {
                              fliterSelected = "Everyone";
                            }

                            if (currentEvent.rolesFilter is Only) {
                              fliterSelected = "Selected";
                            }

                            if (currentEvent.rolesFilter is Not) {
                              fliterSelected = "None ";
                            }

                            var title = "";
                            if (currentEvent is StoryCreated) {
                              title = "Story Created";
                            }
                            if (currentEvent is StoryReacted) {
                              title = "Story Reacted";
                            }

                            if (currentEvent is StoryCommentCreated) {
                              title = "Story Comment";
                              currentEvent.rolesFilter;
                            }
                            return ListTile(
                              title: Text(title),
                              subtitle: Text(fliterSelected),
                              trailing: DropdownButton<String>(
                                value: currentEvent.rolesFilter is All
                                    ? "Everyone"
                                    : currentEvent.rolesFilter is Only
                                        ? "With Roles"
                                        : "None",
                                items: <String>[
                                  'Everyone',
                                  'With Roles',
                                  'None'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentEvent.rolesFilter =
                                        newValue == "Everyone"
                                            ? All()
                                            : newValue == "With Roles"
                                                ? Only(modRoles)
                                                : Not(AmityRoles());
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          if (currentSettings != null) {
                            if (currentSettings?.isEnabled == false) {
                              await AmityCoreClient()
                                  .notifications()
                                  .community(widget.communityId)
                                  .disable()
                                  .then((value) {
                                CommonSnackbar.showPositiveSnackbar(context,
                                    'Success', 'Notification Settings Saved');
                                setState(() {
                                  isloading = false;
                                });
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isloading = false;
                                });
                                CommonSnackbar.showNagativeSnackbar(
                                    context, 'Error', '$error');
                              });
                            } else {
                              List<CommunityNotificationModifier>
                                  communityNotificationModifier = [];
                              currentSettings!.events!.forEach((element) {
                                if (element is StoryCreated) {
                                  late CommunityNotificationModifier
                                      storyCreatedModifier;

                                  if (element.rolesFilter is All) {
                                    storyCreatedModifier =
                                        StoryCreated.enable(All());
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyCreatedModifier =
                                        StoryCreated.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not) {
                                    storyCreatedModifier =
                                        StoryCreated.disable();
                                  }

                                  communityNotificationModifier
                                      .add(storyCreatedModifier);
                                }
                                if (element is StoryReacted) {
                                  late CommunityNotificationModifier
                                      storyReactedModifier;

                                  if (element.rolesFilter is All) {
                                    storyReactedModifier =
                                        StoryReacted.enable(All());
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyReactedModifier =
                                        StoryReacted.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not) {
                                    storyReactedModifier =
                                        StoryReacted.disable();
                                  }

                                  communityNotificationModifier
                                      .add(storyReactedModifier);
                                }
                                if (element is StoryCommentCreated) {
                                  late CommunityNotificationModifier
                                      storyCommentModifier;

                                  if (element.rolesFilter is All) {
                                    storyCommentModifier =
                                        StoryCommentCreated.enable(All());
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyCommentModifier =
                                        StoryCommentCreated.enable(
                                            Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not) {
                                    storyCommentModifier =
                                        StoryCommentCreated.disable();
                                  }

                                  communityNotificationModifier
                                      .add(storyCommentModifier);
                                }
                              });

                              await AmityCoreClient()
                                  .notifications()
                                  .community(widget.communityId)
                                  .enable(communityNotificationModifier)
                                  .then((value) {
                                CommonSnackbar.showPositiveSnackbar(context,
                                    'Success', 'Notification Settings Saved');
                                setState(() {
                                  isloading = false;
                                });
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isloading = false;
                                });
                                CommonSnackbar.showNagativeSnackbar(
                                    context, 'Error', '$error');
                              });
                            }
                          }
                        },
                        child: isloading? const CircularProgressIndicator() : const Text("Save Settings"),
                      )
                    ],
                  ),
                );
              }
            }
            return Container();
          }),
    );
  }
}
