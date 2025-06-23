import 'package:app/model/community/chat/community_chat_model.dart';
import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/people/user_model.dart';

/// Represents a message in a community chat.
///
/// @property id Unique identifier
/// @property community The community chat this message belongs to
/// @property sender The user who sent this message
/// @property contentHash Hashed content of the message
/// @property createdAt When this message was created
/// @property updatedAt When this message was last updated
class CommunityChatMessageModel extends BaseEntityModel {
  final CommunityChatModel community;
  final UserModel sender;
  final String content;

  CommunityChatMessageModel({
    required super.id,
    required this.community,
    required this.sender,
    required this.content,
    super.createdAt,
    required super.updatedAt,
  });
}
