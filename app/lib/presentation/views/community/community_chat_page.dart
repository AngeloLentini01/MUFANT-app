import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:app/data/services/chat_service.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/presentation/widgets/all.dart';

import 'package:app/model/community/chat/all.dart';

import 'package:app/model/generic/people/user_model.dart';
import 'package:app/model/generic/details_model.dart';

import 'package:app/model/cart/cart_model.dart';

import 'package:app/presentation/styles/colors/generic.dart';

import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';

String getLocalizedTimestamp(DateTime? messageTime) {
  if (messageTime == null) return '';
  final now = DateTime.now();
  final diff = now.difference(messageTime);
  if (diff.inMinutes < 1) {
    return 'just_now'.tr();
  } else if (diff.inMinutes < 60) {
    return 'minutes_ago'.tr(namedArgs: {'minutes': diff.inMinutes.toString()});
  } else if (diff.inHours < 24) {
    return 'hours_ago'.tr(namedArgs: {'hours': diff.inHours.toString()});
  } else if (diff.inDays == 1) {
    return 'yesterday'.tr();
  } else {
    return 'days_ago'.tr(namedArgs: {'days': diff.inDays.toString()});
  }
}

class CommunityChatPage extends StatefulWidget {
  final CommunityChatModel community;

  const CommunityChatPage({super.key, required this.community});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  static final Logger _logger = Logger('CommunityChatPage');

  late final ChatService _chatService;
  UserModel? _currentUser;

  List<CommunityChatMessageModel> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _initializeUser();

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

  Future<void> _initializeUser() async {
    _currentUser = await _createCurrentUser();

    // Load demo messages after user is initialized
    if (_currentUser != null) {
      _chatService.loadDemoMessages(widget.community, _currentUser!);
    }
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
    if (_scrollController.hasClients && _messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  /// Create current user for demo or use actual logged-in user
  Future<UserModel> _createCurrentUser() async {
    final sessionUser = UserSessionManager.currentUser;
    if (sessionUser != null) {
      // Convert User to UserModel
      final now = DateTime.now();

      // Try to get saved avatar from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedAvatar = prefs.getString(
        'user_avatar_${sessionUser.username}',
      );

      return UserModel(
        id: Ulid(),
        username: sessionUser.username,
        email: sessionUser.email,
        passwordHash: Uint8List.fromList([]), // Empty for chat display
        cart: CartModel(id: Ulid(), cartItems: [], updatedAt: now),
        details: DetailsModel(
          id: Ulid(),
          name: sessionUser.firstName ?? sessionUser.username,
          description: 'Current user',
          notes: 'Logged in user',
          imageUrlOrPath:
              savedAvatar ??
              'assets/images/avatar/avatar_robot.png', // Default avatar
          updatedAt: now,
        ),
        createdAt: sessionUser.createdAt,
        updatedAt: sessionUser.updatedAt,
      );
    }

    // Fallback to demo user if no one is logged in
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
        imageUrlOrPath:
            'assets/images/avatar/avatar_robot.png', // Default avatar
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );
  }

  void _handleSendPressed() async {
    final textMessage = _messageController.text.trim();
    _logger.info('Send button pressed with message: "$textMessage"');

    if (textMessage.isNotEmpty && _currentUser != null) {
      try {
        _logger.info('Attempting to send message...');
        await _chatService.sendMessage(
          community: widget.community,
          sender: _currentUser!,
          content: textMessage,
        );
        _logger.info('Message sent successfully!');
        _messageController.clear();
      } catch (e) {
        _logger.severe('Error sending message: $e');
        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${'failed_to_send_message'.tr()}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      _logger.warning('Message is empty, not sending');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor, size: 24),
        ),
        title: Text(
          'chat_title'.tr(),
          style: const TextStyle(
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kBlackColor,
        foregroundColor: kWhiteColor,
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
                reverse: true,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isCurrentUser =
                      _currentUser != null &&
                      message.sender.id == _currentUser!.id;
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
                        color: Colors.black.withValues(alpha: .2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(
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
                    getLocalizedTimestamp(message.createdAt),
                    style: TextStyle(fontSize: 10, color: Colors.grey[400]),
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
    return SizedBox(
      width: 32,
      height: 32,
      child: ClipOval(
        child:
            user.details.imageUrlOrPath != null &&
                user.details.imageUrlOrPath!.isNotEmpty
            ? Image.asset(
                user.details.imageUrlOrPath!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to letter avatar with pink background if image fails to load
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
                },
              )
            : Container(
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
            color: Colors.black.withValues(alpha: .3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[600]!, width: 1),
                ),
                child: FilteredTextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'chat_input_placeholder'.tr(),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _handleSendPressed();
                    }
                  },
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
                onPressed: () {
                  _logger.info('Send button tapped!');
                  _handleSendPressed();
                },
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
}
