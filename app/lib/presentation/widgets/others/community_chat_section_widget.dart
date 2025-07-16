import 'package:app/presentation/styles/spacing/community.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/widgets/community_chats_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CommunityChatSectionWidget extends StatelessWidget {
  const CommunityChatSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final kParagraphTextstyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[300],
      height: 1.5,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('connect_with_users'.tr(), style: kSectionTitleTextStyle),
          kSpaceBetweenCommunityTitleAndParagraph,
          Text('community_description'.tr(), style: kParagraphTextstyle),
          kSpaceBetweenCommunityCTAAndButton,
          CommunityChatsButton(
            label: 'join_community_discussions'.tr(),
            showLabel: true,
          ),
        ],
      ),
    );
  }
}
