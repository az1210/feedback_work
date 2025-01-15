class GroupUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? avaterUrl;
  GroupUser({
    this.id,
    this.firstName,
    this.lastName,
    this.avaterUrl,
  });

  GroupUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? avaterUrl,
  }) {
    return GroupUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avaterUrl: avaterUrl ?? this.avaterUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avaterUrl': avaterUrl,
    };
  }

  factory GroupUser.fromMap(Map<String, dynamic> map) {
    return GroupUser(
      id: map['id'] != null ? map['id'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      avaterUrl: map['avaterUrl'] != null ? map['avaterUrl'] as String : null,
    );
  }
}

class GroupModel {
  final String? id;
  final String? ownerId;
  final String name;
  final String? description;
  final bool? isPublic;
  final List<GroupUser>? users;
  GroupModel({
    this.id,
    this.ownerId,
    required this.name,
    this.description,
    this.isPublic,
    this.users,
  });

  GroupModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    bool? isPublic,
    List<GroupUser>? users,
  }) {
    return GroupModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'isPublic': isPublic,
      'users': users?.map((x) => x.toMap()).toList(),
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
      users: map['users'] != null
          ? List<GroupUser>.from(
              (map['users'] as List<dynamic>).map<GroupUser?>(
                (x) => GroupUser.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
