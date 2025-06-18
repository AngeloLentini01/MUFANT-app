import 'package:app/data/museum/subscription_model.dart';
import 'package:app/data/generic/people/user_model.dart';

/// Represents additional details for a visitor in the system.
/// 
/// @property id Unique identifier
/// @property user The user associated with these visitor details (can be null)
/// @property subscription The subscription associated with this visitor (can be null)
class MuseumVisitorModel extends UserModel {
  late bool isCommunityChatEnabled = false;
  final SubscriptionModel? subscription;
  bool get isSubscribed => subscription?.isActive ?? false;

  MuseumVisitorModel({
    required super.id,
    this.subscription,
    required super.username,
    required super.email,
    required super.passwordHash, required super.cart, required super.details, required super.createdAt, required super.updatedAt});

}
