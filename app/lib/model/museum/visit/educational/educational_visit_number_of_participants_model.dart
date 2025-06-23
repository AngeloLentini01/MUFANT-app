import 'package:app/model/generic/base_entity_model.dart';

/// Represents the count of participants for an educational visit.
/// This is used to track and manage attendance for educational visits.
///
/// @property id Unique identifier for this record
/// @property educational The associated educational visit
/// @property actualParticipants The actual number of participants that attended
/// @property registeredParticipants The number of participants that registered in advance
/// @property numberOfTeachers The number of teachers/chaperones accompanying the students
/// @property schoolName Name of the school or educational institution
/// @property createdAt When this record was created
/// @property updatedAt When this record was last updated
class EducationalVisitNumberOfParticipantsModel extends BaseEntityModel {
  final int numOfParticipants;
  final int numberOfAccompaniers;

  EducationalVisitNumberOfParticipantsModel({
    required super.id,
    required this.numOfParticipants,
    required this.numberOfAccompaniers,
    super.createdAt,
    required super.updatedAt,
  });
}
