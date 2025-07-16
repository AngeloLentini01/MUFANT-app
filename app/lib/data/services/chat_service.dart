import 'dart:async';
import 'dart:typed_data';
import 'package:app/model/community/chat/community_chat_message_model.dart';
import 'package:app/model/community/chat/community_chat_model.dart';
import 'package:app/model/generic/people/user_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/cart/cart_model.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';

/// Service class to handle chat operations
class ChatService {
  static final Logger _logger = Logger('ChatService');

  // Stream controller for real-time message updates
  final StreamController<List<CommunityChatMessageModel>> _messagesController =
      StreamController<List<CommunityChatMessageModel>>.broadcast();

  // In-memory storage for demo purposes (replace with actual database)
  final List<CommunityChatMessageModel> _messages = [];

  Stream<List<CommunityChatMessageModel>> get messagesStream =>
      _messagesController.stream;

  /// Get all messages for a specific community chat
  List<CommunityChatMessageModel> getMessages(CommunityChatModel community) {
    return _messages
        .where((message) => message.community.id == community.id)
        .toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  /// Send a new message to the community chat
  Future<void> sendMessage({
    required CommunityChatModel community,
    required UserModel sender,
    required String content,
  }) async {
    try {
      _logger.info('Creating new message for ${community.details.name}');

      final now = DateTime.now();
      final message = CommunityChatMessageModel(
        id: Ulid(),
        community: community,
        sender: sender,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      _logger.info('Adding message to list');
      _messages.add(message);
      _logger.info('Message sent by ${sender.details.name}: $content');

      // Notify listeners of the update
      _messagesController.add(getMessages(community));
      _logger.info('Message sent successfully');
    } catch (e) {
      _logger.severe('Error sending message: $e');
      rethrow;
    }
  }

  /// Load initial demo messages
  void loadDemoMessages(CommunityChatModel community, UserModel currentUser) {
    final now = DateTime.now();
    final demoMessages = [
      CommunityChatMessageModel(
        id: Ulid(),
        community: community,
        sender: _createDemoUser('Museum Guide', 'guide@museum.com'),
        content:
            'Welcome to the community chat! Feel free to ask questions about our exhibits.',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      CommunityChatMessageModel(
        id: Ulid(),
        community: community,
        sender: _createDemoUser('Art Enthusiast', 'art.lover@email.com'),
        content:
            'The new contemporary art exhibition is amazing! Has anyone else seen it?',
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      CommunityChatMessageModel(
        id: Ulid(),
        community: community,
        sender: _createDemoUser('History Buff', 'history@email.com'),
        content:
            'I loved learning about the ancient artifacts section. The storytelling was incredible!',
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];

    _messages.addAll(demoMessages);
    _messagesController.add(getMessages(community));
    _logger.info(
      'Loaded ${demoMessages.length} demo messages for ${community.details.name}',
    );
  }

  /// Create a demo user for testing purposes
  UserModel _createDemoUser(String name, String email) {
    final now = DateTime.now();
    return UserModel(
      id: Ulid(),
      //todo: check if this is changing name in the homepage greeting
      username: name.replaceAll(' ', '_'),
      email: email,
      passwordHash: Uint8List.fromList([]), // Empty for demo
      cart: _createEmptyCart(),
      details: DetailsModel(
        id: Ulid(),
        name: name,
        description: 'Demo user',
        notes: 'Created for demo purposes',
        updatedAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create an empty cart for demo users
  CartModel _createEmptyCart() {
    return CartModel(id: Ulid(), cartItems: [], updatedAt: DateTime.now());
  }

  void dispose() {
    _messagesController.close();
  }
}
