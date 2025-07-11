class ActivityDetails {
  final int? id;
  final int activityId;
  final String? location;
  final String? startTime;
  final String? endTime;
  final String? schedule;
  final String? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityDetails({
    this.id,
    required this.activityId,
    this.location,
    this.startTime,
    this.endTime,
    this.schedule,
    this.additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create an ActivityDetails object from a map
  factory ActivityDetails.fromMap(Map<String, dynamic> map) {
    return ActivityDetails(
      id: map['id'],
      activityId: map['activity_id'],
      location: map['location'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      schedule: map['schedule'],
      additionalInfo: map['additional_info'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // Convert an ActivityDetails object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
      'schedule': schedule,
      'additional_info': additionalInfo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this ActivityDetails with the given fields updated
  ActivityDetails copyWith({
    int? id,
    int? activityId,
    String? location,
    String? startTime,
    String? endTime,
    String? schedule,
    String? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityDetails(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      schedule: schedule ?? this.schedule,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
