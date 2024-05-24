import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/widget/common_snackbar.dart';
import 'package:path/path.dart';

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
                if (currentSettings == null) {
                  print("newValue: Data set For the firstTime");
                  currentSettings = snapshot.data;
                }
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
                            var fliterSelected = "";

                            if (currentSettings!.events![index].rolesFilter
                                is All) {
                              fliterSelected = "Everyone";
                            }

                            if (currentSettings!.events![index].rolesFilter
                                is Only) {
                              fliterSelected = "With Roles";
                            }

                            if (currentSettings!.events![index].isEnabled ==
                                false) {
                              fliterSelected = "None";
                            }

                            var title = "";
                            if (currentSettings!.events![index]
                                is StoryCreated) {
                              title = "Story Created";
                            }
                            if (currentSettings!.events![index]
                                is StoryReacted) {
                              title = "Story Reacted";
                            }

                            if (currentSettings!.events![index]
                                is StoryCommentCreated) {
                              title = "Story Comment";
                            }

                            if (currentSettings!.events![index]
                                is PostCreated) {
                              title = "Post Created";
                            }

                            if (currentSettings!.events![index]
                                is PostReacted) {
                              title = "Post Reacted";
                            }

                            if (currentSettings!.events![index]
                                is CommentCreated) {
                              title = "Comment Created";
                            }

                            if (currentSettings!.events![index]
                                is CommentReacted) {
                              title = "Comment Reacted";
                            }

                            if (currentSettings!.events![index]
                                is CommentReplied) {
                              title = "Comment Replied";
                            }

                            return ListTile(
                              title: Text(title),
                              subtitle: Text(fliterSelected),
                              trailing: (currentSettings!
                                          .events![index].isNetworkEnabled ==
                                      false)
                                  ? const Text("Network Disabled")
                                  : DropdownButton<String>(
                                      value: currentSettings!
                                                  .events![index].isEnabled ==
                                              false
                                          ? "None"
                                          : currentSettings!.events![index]
                                                  .rolesFilter is All
                                              ? "Everyone"
                                              : currentSettings!.events![index]
                                                      .rolesFilter is Only
                                                  ? "With Roles"
                                                  : "None",
                                      items: <String>[
                                        'Everyone',
                                        'With Roles',
                                        'None'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          fliterSelected = newValue!;

                                          switch (newValue) {
                                            case "Everyone":
                                              currentSettings!.events![index]
                                                  .isEnabled = true;
                                              currentSettings!.events![index]
                                                  .rolesFilter = All();

                                              break;
                                            case "With Roles":
                                              currentSettings!.events![index]
                                                  .isEnabled = true;
                                              currentSettings!.events![index]
                                                  .rolesFilter = Only(modRoles);
                                              break;
                                            case "None":
                                              currentSettings!.events![index]
                                                  .isEnabled = false;
                                              currentSettings!.events![index]
                                                      .rolesFilter =
                                                  Not(AmityRoles());
                                              break;
                                          }
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
                                        StoryCreated.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyCreatedModifier =
                                        StoryCreated.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    storyCreatedModifier =
                                        StoryCreated.disable();
                                  }
                                  if (element.isNetworkEnabled) {
                                    communityNotificationModifier
                                        .add(storyCreatedModifier);
                                  }
                                }
                                if (element is StoryReacted) {
                                  late CommunityNotificationModifier
                                      storyReactedModifier;

                                  if (element.rolesFilter is All) {
                                    storyReactedModifier =
                                        StoryReacted.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyReactedModifier =
                                        StoryReacted.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    storyReactedModifier =
                                        StoryReacted.disable();
                                  }

                                  if (element.isNetworkEnabled) {
                                    communityNotificationModifier
                                        .add(storyReactedModifier);
                                  }
                                }
                                if (element is StoryCommentCreated) {
                                  late CommunityNotificationModifier
                                      storyCommentModifier;

                                  if (element.rolesFilter is All) {
                                    storyCommentModifier =
                                        StoryCommentCreated.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    storyCommentModifier =
                                        StoryCommentCreated.enable(
                                            Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    storyCommentModifier =
                                        StoryCommentCreated.disable();
                                  }

                                  if (element.isNetworkEnabled) {
                                    communityNotificationModifier
                                        .add(storyCommentModifier);
                                  }
                                }

                                if (element is PostCreated) {
                                  late CommunityNotificationModifier
                                      postCreatedModifier;

                                  if (element.rolesFilter is All) {
                                    postCreatedModifier =
                                        PostCreated.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    postCreatedModifier =
                                        PostCreated.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    postCreatedModifier = PostCreated.disable();
                                  }
                                  if(element.isNetworkEnabled){
                                    communityNotificationModifier
                                      .add(postCreatedModifier);
                                  }
                                  
                                }

                                if (element is PostReacted) {
                                  late CommunityNotificationModifier
                                      postReacteModifier;

                                  if (element.rolesFilter is All) {
                                    postReacteModifier =
                                        PostReacted.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    postReacteModifier =
                                        PostReacted.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    postReacteModifier = PostReacted.disable();
                                  }

                                  if(element.isNetworkEnabled){
                                    communityNotificationModifier
                                      .add(postReacteModifier);
                                  }

                                }

                                if (element is CommentCreated) {
                                  late CommunityNotificationModifier
                                      commentCreatedModifier;

                                  if (element.rolesFilter is All) {
                                    commentCreatedModifier =
                                        CommentCreated.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    commentCreatedModifier =
                                        CommentCreated.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    commentCreatedModifier =
                                        CommentCreated.disable();
                                  }

                                  if(element.isNetworkEnabled){
                                    communityNotificationModifier
                                      .add(commentCreatedModifier);
                                  }

                                }

                                if (element is CommentReacted) {
                                  late CommunityNotificationModifier
                                      commentReactedModifier;

                                  if (element.rolesFilter is All) {
                                    commentReactedModifier =
                                        CommentReacted.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    commentReactedModifier =
                                        CommentReacted.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    commentReactedModifier =
                                        CommentReacted.disable();
                                  }

                                  if(element.isNetworkEnabled){
                                    communityNotificationModifier
                                      .add(commentReactedModifier);
                                  }
                                }

                                if (element is CommentReplied) {
                                  late CommunityNotificationModifier
                                      commentRepliedModifier;

                                  if (element.rolesFilter is All) {
                                    commentRepliedModifier =
                                        CommentReplied.enable(null);
                                  }
                                  if (element.rolesFilter is Only) {
                                    commentRepliedModifier =
                                        CommentReplied.enable(Only(modRoles));
                                  }
                                  if (element.rolesFilter is Not ||
                                      element.isEnabled == false) {
                                    commentRepliedModifier =
                                        CommentReplied.disable();
                                  }
                                  if(element.isNetworkEnabled){
                                    communityNotificationModifier
                                      .add(commentRepliedModifier);
                                  }
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
                        child: isloading
                            ? const CircularProgressIndicator()
                            : const Text("Save Settings"),
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
