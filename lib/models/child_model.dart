class ChildModel {
  final String id;
  final String avaterUrl;
  final String firstName;
  final String lastName;
  final String ageRange;
  final String grade;
  final String email;
  ChildModel({
    this.id = '',
    this.avaterUrl = '',
    this.firstName = '',
    this.lastName = '',
    this.ageRange = '',
    this.grade = '',
    this.email = '',
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
      avaterUrl: imageUrl ?? avaterUrl,
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
      id: map['id'] as String? ?? '',
      avaterUrl: map['imageUrl'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      ageRange: map['ageRange'] as String? ?? '',
      grade: map['grade'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }
}
