import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/community_chats_button.dart';
import 'package:flutter/material.dart';

class CommunityChatSectionWidget extends StatelessWidget {
  const CommunityChatSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect with Other Visitors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPinkColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Join our community discussions and share your museum experience!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          const CommunityChatsButton(
            label: 'Join Community Discussions',
            showLabel: true,
          ),
        ],
      ),
    );
  }
}
