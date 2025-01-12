class GroupModel {
  final String? id;
  final String? ownerId;
  final String name;
  final String? description;
  final bool? isPublic;
  final List<String>? uIds;
  GroupModel({
    this.id,
    this.ownerId,
    required this.name,
    this.description,
    required this.isPublic,
    this.uIds,
  });

  GroupModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    bool? isPrivate,
    List<String>? uIds,
  }) {
    return GroupModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      isPublic: isPrivate ?? isPublic,
      uIds: uIds ?? this.uIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name.trim(),
      'ownerId': ownerId?.trim(),
      'description': description?.trim(),
      'isPublic': isPublic,
      'uIds': uIds,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] != null ? map['id'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      isPublic: map['isPublic'] != null ? map['isPublic'] as bool : null,
      uIds: map['uIds'] != null
          ? List<String>.from((map['uIds'] as List<dynamic>))
          : null,
    );
  }
}
