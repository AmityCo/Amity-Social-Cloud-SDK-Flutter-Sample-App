import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_sample_app/core/utils/reaction_utils.dart';

class ReactionWidget extends StatelessWidget {
  const ReactionWidget({Key? key, required this.reaction}) : super(key: key);
  final AmityReaction reaction;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.black12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: reaction.creator?.avatarUrl != null
                ? Image.network(
                    reaction.creator!.avatarUrl!,
                    fit: BoxFit.fill,
                  )
                : Image.asset('assets/user_placeholder.png'),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(child: Text(reaction.creator?.displayName ?? "")),
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.withOpacity(.7)),
            child: Image.asset(
              ReactionUtils.getActiveReactionAssets(
                reaction.reactionName!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
