import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/data/services/chat_service.dart';
import 'package:app/model/community/chat/community_chat_model.dart';
import 'package:app/model/community/chat/community_chat_message_model.dart';
import 'package:app/model/generic/people/user_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/cart/cart_model.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:ulid/ulid.dart';

class CommunityChatPage extends StatefulWidget {
  final CommunityChatModel community;

  const CommunityChatPage({super.key, required this.community});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  late final ChatService _chatService;
  late final UserModel _currentUser;
  List<CommunityChatMessageModel> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _currentUser = _createCurrentUser();

    // Load demo messages
    _chatService.loadDemoMessages(widget.community, _currentUser);

    // Listen to message updates
    _chatService.messagesStream.listen((messages) {
      setState(() {
        _messages = messages;
      });
      _scrollToBottom();
    });

    // Load initial messages
    _loadMessages();
  }

  @override
  void dispose() {
    _chatService.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final messages = _chatService.getMessages(widget.community);
    setState(() {
      _messages = messages;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Create current user for demo
  UserModel _createCurrentUser() {
    final now = DateTime.now();
    return UserModel(
      id: Ulid(),
      username: 'current_user',
      email: 'user@museum.com',
      passwordHash: Uint8List.fromList([]),
      cart: CartModel(id: Ulid(), cartItems: [], updatedAt: now),
      details: DetailsModel(
        id: Ulid(),
        name: 'You',
        description: 'Current user',
        notes: 'Current logged in user',
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );
  }

  void _handleSendPressed() async {
    final textMessage = _messageController.text.trim();
    if (textMessage.isNotEmpty) {
      try {
        await _chatService.sendMessage(
          community: widget.community,
          sender: _currentUser,
          content: textMessage,
        );
        _messageController.clear();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.community.details.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kBlackColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBlackColor, Colors.grey[900]!],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isCurrentUser = message.sender.id == _currentUser.id;
                  return _buildMessageBubble(message, isCurrentUser);
                },
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    CommunityChatMessageModel message,
    bool isCurrentUser,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            _buildAvatar(message.sender),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      message.sender.details.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? kPinkColor : Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    _formatTime(message.createdAt ?? DateTime.now()),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(message.sender),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPinkColor.withValues(alpha: .8), kPinkColor],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user.details.name.isNotEmpty
              ? user.details.name[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border(top: BorderSide(color: Colors.grey[700]!, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[600]!, width: 1),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about the museum...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: null,
                  onSubmitted: (_) => _handleSendPressed(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: kPinkColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _handleSendPressed,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Send message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
