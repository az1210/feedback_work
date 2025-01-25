import 'package:feedback_work/models/user_model.dart';

class GroupModel {
  final String? id;
  final String? ownerId;
  final String? name;
  final String? description;
  final bool? isPublic;
  final List<UserModel>? users;
  GroupModel({
    this.id = '',
    this.ownerId = '',
    this.name = '',
    this.description = '',
    this.isPublic = false,
    this.users = const [],
  });

  GroupModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    bool? isPublic,
    List<UserModel>? users,
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
      id: map['id'] as String? ?? '',
      ownerId: map['ownerId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isPublic: map['isPublic'] as bool,
      users: (map['users'] as List<dynamic>)
          .map(
            (x) => UserModel.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
