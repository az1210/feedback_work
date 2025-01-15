import 'package:feedback_work/models/user_model.dart';

class GroupModel {
  final String? id;
  final String? ownerId;
  final String name;
  final String? description;
  final bool? isPublic;
  final List<UserModel>? users;
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
      id: map['id'] != null ? map['id'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      isPublic: map['isPublic'] != null ? map['isPublic'] as bool : null,
      users: map['users'] != null
          ? List<UserModel>.from(
              (map['users'] as List<dynamic>).map<UserModel?>(
                (x) => UserModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
