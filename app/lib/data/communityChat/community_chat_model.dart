import 'package:app/data/generic/details_model.dart';
import 'package:app/data/generic/people/staff/staff_member_model.dart';
import 'package:ulid/ulid.dart';

/// Represents a community chat where users can participate in group discussions.
///
/// @property id Unique identifier
/// @property details Descriptive information about the community chat
class CommunityChatModel {
  final Ulid id;
  final DetailsModel details;
  late StaffMemberModel owner;
  CommunityChatModel(this.owner, {required this.id, required this.details});
}
