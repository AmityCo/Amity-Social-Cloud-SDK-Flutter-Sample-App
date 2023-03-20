import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/route/app_route.dart';
import 'package:flutter_social_sample_app/core/widget/dialog/error_dialog.dart';
import 'package:flutter_social_sample_app/core/widget/raw_data_widget.dart';
import 'package:go_router/go_router.dart';

class CommunityProfileInfoWidget extends StatelessWidget {
  const CommunityProfileInfoWidget({Key? key, required this.amityCommunity})
      : super(key: key);
  final AmityCommunity amityCommunity;
  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child:
                    amityCommunity.avatarImage?.getUrl(AmityImageSize.MEDIUM) !=
                            null
                        ? Image.network(
                            amityCommunity.avatarImage!
                                .getUrl(AmityImageSize.MEDIUM),
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/user_placeholder.png'),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${amityCommunity.postsCount}\n',
                            style: _themeData.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'Posts',
                              style: _themeData.textTheme.bodyText2),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${amityCommunity.membersCount}\n',
                            style: _themeData.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'Members',
                              style: _themeData.textTheme.bodyText2),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amityCommunity.displayName ?? '',
            style: _themeData.textTheme.headline6,
          ),
          const SizedBox(height: 8),
          Text(
            amityCommunity.description ?? '',
            style: _themeData.textTheme.caption,
          ),
          const SizedBox(height: 18),
          FutureBuilder<List<String>>(
            future: amityCommunity.getCurentUserRoles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Rolse - ${snapshot.data!.join(',')}');
              }
              if (snapshot.hasError) {
                // print(snapshot.error.toString());
              }
              return Container();
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: () {
                  if (!(amityCommunity.isJoined ?? true)) {
                    AmitySocialClient.newCommunityRepository()
                        .joinCommunity(amityCommunity.communityId!)
                        .then((value) {})
                        .onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  } else {
                    AmitySocialClient.newCommunityRepository()
                        .leaveCommunity(amityCommunity.communityId!)
                        .then((value) {})
                        .onError((error, stackTrace) {
                      ErrorDialog.show(context,
                          title: 'Error', message: error.toString());
                    });
                  }
                },
                child:
                    Text(!(amityCommunity.isJoined ?? true) ? 'Join' : 'Leave'),
              ),
            ),
          ),
          if (amityCommunity
                  .hasPermission(AmityPermission.REVIEW_COMMUNITY_POST) &&
              amityCommunity.isPostReviewEnabled!)
            Center(
              child: SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                        AppRoute.communityInReviewPost,
                        queryParams: {
                          'communityId': amityCommunity.communityId,
                          'isPublic': amityCommunity.isPublic!.toString()
                        });
                  },
                  child: const Text('Review Post'),
                ),
              ),
            )
          else
            Center(
              child: SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(AppRoute.communityPendingPost, queryParams: {
                      'communityId': amityCommunity.communityId,
                      'isPublic': amityCommunity.isPublic!.toString()
                    });
                  },
                  child: const Text('Pending Post'),
                ),
              ),
            ),
          RawDataWidget(jsonRawData: amityCommunity.toJson()),
        ],
      ),
    );
  }
}
