class MuseumActivity {
  final int? id;
  final String name;
  final String type; // 'event' or 'room'
  final String description;
  final double price;
  final String? imagePath;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MuseumActivity({
    this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    this.imagePath,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create a MuseumActivity object from a map
  factory MuseumActivity.fromMap(Map<String, dynamic> map) {
    return MuseumActivity(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      description: map['description'],
      price: map['price'],
      imagePath: map['image_path'],
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // Convert a MuseumActivity object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'price': price,
      'image_path': imagePath,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this MuseumActivity with the given fields updated
  MuseumActivity copyWith({
    int? id,
    String? name,
    String? type,
    String? description,
    double? price,
    String? imagePath,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MuseumActivity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
