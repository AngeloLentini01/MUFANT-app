import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/model/community/chat/community_chat_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/generic/people/staff/staff_member_model.dart';
import 'package:app/model/generic/people/staff/staff_roles.dart';
import 'package:app/model/cart/cart_model.dart';
import 'package:app/presentation/views/community_chat_page.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';

class CommunityChatsListPage extends StatefulWidget {
  const CommunityChatsListPage({super.key});

  @override
  State<CommunityChatsListPage> createState() => _CommunityChatsListPageState();
}

class _CommunityChatsListPageState extends State<CommunityChatsListPage> {
  static final Logger _logger = Logger('CommunityChatsListPage');
  late final List<CommunityChatModel> _communityChats;

  @override
  void initState() {
    super.initState();
    _communityChats = _createDemoChats();
  }

  /// Create demo community chats
  List<CommunityChatModel> _createDemoChats() {
    final now = DateTime.now();

    return [
      CommunityChatModel(
        _createDemoStaffMember('Museum Curator', 'curator@museum.com'),
        id: Ulid(),
        details: DetailsModel(
          id: Ulid(),
          name: '🎨 Art Discussion',
          description:
              'Discuss contemporary art, exhibitions, and artistic techniques with fellow art enthusiasts.',
          notes: 'Active community with daily discussions',
          imageUrlOrPath: 'assets/images/art_chat.png',
          updatedAt: now,
        ),
      ),
      CommunityChatModel(
        _createDemoStaffMember('History Expert', 'history@museum.com'),
        id: Ulid(),
        details: DetailsModel(
          id: Ulid(),
          name: '🏛️ History & Artifacts',
          description:
              'Explore historical artifacts, ancient civilizations, and archaeological discoveries.',
          notes: 'Educational discussions about museum collections',
          imageUrlOrPath: 'assets/images/history_chat.png',
          updatedAt: now,
        ),
      ),
      CommunityChatModel(
        _createDemoStaffMember('Science Guide', 'science@museum.com'),
        id: Ulid(),
        details: DetailsModel(
          id: Ulid(),
          name: '🔬 Science & Discovery',
          description:
              'Share your curiosity about scientific innovations, discoveries, and interactive exhibits.',
          notes: 'Perfect for families and science enthusiasts',
          imageUrlOrPath: 'assets/images/science_chat.png',
          updatedAt: now,
        ),
      ),
      CommunityChatModel(
        _createDemoStaffMember('Event Coordinator', 'events@museum.com'),
        id: Ulid(),
        details: DetailsModel(
          id: Ulid(),
          name: '📅 Events & Workshops',
          description:
              'Stay updated on upcoming events, workshops, and special exhibitions.',
          notes: 'Get exclusive early access information',
          imageUrlOrPath: 'assets/images/events_chat.png',
          updatedAt: now,
        ),
      ),
      CommunityChatModel(
        _createDemoStaffMember('Visitor Services', 'help@museum.com'),
        id: Ulid(),
        details: DetailsModel(
          id: Ulid(),
          name: '💬 General Chat',
          description:
              'General discussions, questions, and community interactions about your museum experience.',
          notes: 'Welcome newcomers and share experiences',
          imageUrlOrPath: 'assets/images/general_chat.png',
          updatedAt: now,
        ),
      ),
    ];
  }

  /// Create demo staff member
  StaffMemberModel _createDemoStaffMember(String name, String email) {
    final now = DateTime.now();
    return StaffMemberModel(
      id: Ulid(),
      username: name.toLowerCase().replaceAll(' ', '_'),
      email: email,
      passwordHash: Uint8List.fromList([]), // Empty for demo
      cart: CartModel(id: Ulid(), cartItems: [], updatedAt: now),
      details: DetailsModel(
        id: Ulid(),
        name: name,
        description: 'Museum staff member',
        notes: 'Professional museum staff',
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
      role: StaffRoles.employee,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Chats',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kBlackColor,
        foregroundColor: kWhiteColor,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search functionality
                _logger.info('Search button pressed');
              },
              tooltip: 'Search chats',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _communityChats.length,
          itemBuilder: (context, index) {
            final chat = _communityChats[index];
            return _buildChatCard(context, chat);
          },
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, CommunityChatModel chat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[850]!, Colors.grey[800]!],
          ),
          border: Border.all(
            color: kPinkColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPinkColor.withValues(alpha: 0.8), kPinkColor],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPinkColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getEmojiFromTitle(chat.details.name),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          title: Text(
            chat.details.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kWhiteColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                chat.details.description ?? 'No description available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 16, color: kPinkColor),
                  const SizedBox(width: 4),
                  Text(
                    _getParticipantCount(chat),
                    style: TextStyle(
                      fontSize: 12,
                      color: kPinkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            _logger.info('Opening chat: ${chat.details.name}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityChatPage(community: chat),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Extract emoji from chat title
  String _getEmojiFromTitle(String title) {
    final regex = RegExp(
      r'[\u{1f300}-\u{1f5ff}\u{1f900}-\u{1f9ff}\u{1f600}-\u{1f64f}\u{1f680}-\u{1f6ff}\u{2600}-\u{26ff}\u{2700}-\u{27bf}]',
      unicode: true,
    );
    final match = regex.firstMatch(title);
    return match?.group(0) ?? '💬';
  }

  /// Get mock participant count
  String _getParticipantCount(CommunityChatModel chat) {
    // Mock participant counts based on chat type
    switch (chat.details.name) {
      case '🎨 Art Discussion':
        return '47 members';
      case '🏛️ History & Artifacts':
        return '32 members';
      case '🔬 Science & Discovery':
        return '28 members';
      case '📅 Events & Workshops':
        return '156 members';
      case '💬 General Chat':
        return '89 members';
      default:
        return '12 members';
    }
  }
}
