class ChildModel {
  final String? id;
  final String? avaterUrl;
  final String? firstName;
  final String? lastName;
  final String? ageRange;
  final String? grade;
  final String? email;
  ChildModel({
    this.id,
    this.avaterUrl,
    this.firstName,
    this.lastName,
    this.ageRange,
    this.grade,
    this.email,
  });

  ChildModel copyWith({
    String? id,
    String? imageUrl,
    String? firstName,
    String? lastName,
    String? ageRange,
    String? grade,
    String? email,
  }) {
    return ChildModel(
      id: id ?? this.id,
      avaterUrl: imageUrl ?? this.avaterUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      ageRange: ageRange ?? this.ageRange,
      grade: grade ?? this.grade,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': avaterUrl,
      'firstName': firstName,
      'lastName': lastName,
      'ageRange': ageRange,
      'grade': grade,
      'email': email,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['id'] != null ? map['id'] as String : null,
      avaterUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      ageRange: map['ageRange'] != null ? map['ageRange'] as String : null,
      grade: map['grade'] != null ? map['grade'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}
