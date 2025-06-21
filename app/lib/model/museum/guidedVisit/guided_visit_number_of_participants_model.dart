import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/museum/guidedVisit/guided_visit_model.dart';
import 'package:ulid/ulid.dart';

/// Represents the count of participants for a guided visit.
/// This is used to track and manage attendance for guided visits.
///
/// @property id Unique identifier for this record
/// @property guidedVisit The associated guided visit
/// @property actualParticipants The actual number of participants that attended
/// @property registeredParticipants The number of participants that registered in advance
/// @property createdAt When this record was created
/// @property updatedAt When this record was last updated
class GuidedVisitNumberOfParticipantsModel extends BaseEntityModel {
  final GuidedVisitModel guidedVisit;
  final int actualParticipants;
  final int registeredParticipants;

  GuidedVisitNumberOfParticipantsModel({
    required super.id,
    required this.guidedVisit,
    required this.actualParticipants,
    required this.registeredParticipants,
    super.createdAt,
    required super.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuidedVisitNumberOfParticipantsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          guidedVisit == other.guidedVisit &&
          actualParticipants == other.actualParticipants &&
          registeredParticipants == other.registeredParticipants &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      guidedVisit.hashCode ^
      actualParticipants.hashCode ^
      registeredParticipants.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'GuidedVisitNumberOfParticipantsModel(id: $id, guidedVisit: $guidedVisit, '
      'actualParticipants: $actualParticipants, registeredParticipants: $registeredParticipants, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';

  GuidedVisitNumberOfParticipantsModel copyWith({
    Ulid? id,
    GuidedVisitModel? guidedVisit,
    int? actualParticipants,
    int? registeredParticipants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GuidedVisitNumberOfParticipantsModel(
      id: id ?? this.id,
      guidedVisit: guidedVisit ?? this.guidedVisit,
      actualParticipants: actualParticipants ?? this.actualParticipants,
      registeredParticipants:
          registeredParticipants ?? this.registeredParticipants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
