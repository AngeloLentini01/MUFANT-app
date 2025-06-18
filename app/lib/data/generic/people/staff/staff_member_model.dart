import 'package:app/data/generic/people/staff/staff_roles.dart';
import 'package:app/data/generic/people/user_model.dart';

/// Represents a staff member with specific role in the system.
/// 
/// @property id Unique identifier for the staff member
/// @property user The user associated with this staff member
/// @property role The role assigned to this staff member
class StaffMemberModel extends UserModel {
  final StaffRoles role;

  StaffMemberModel({
    required super.id,
    required this.role,
    required super.username,
    required super.email,
    required super.passwordHash,
    required super.cart,
    required super.details,
    required super.createdAt,
    required super.updatedAt,
  });
}
