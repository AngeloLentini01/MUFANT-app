import 'package:app/presentation/styles/spacing/community.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/widgets/community_chats_button.dart';
import 'package:flutter/material.dart';

class CommunityChatSectionWidget extends StatelessWidget {
  const CommunityChatSectionWidget({
    super.key,
  });

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
          Text(
            'Connect with Other Visitors',
            style: kSectionTitleTextStyle,
          ),
          kSpaceBetweenCommunityTitleAndParagraph,
          Text(
            'Join our community discussions and share your museum experience!',
            style: kParagraphTextstyle,
          ),
          kSpaceBetweenCommunityCTAAndButton,
          const CommunityChatsButton(
            label: 'Join Community Discussions',
            showLabel: true,
          ),
        ],
      ),
    );
  }
}
