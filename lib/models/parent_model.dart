class ParentModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avaterUrl;
  final String? relationship;
  final String? residence;
  ParentModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avaterUrl,
    this.relationship,
    this.residence,
  });

  ParentModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avaterUrl,
    String? relationship,
    String? residense,
  }) {
    return ParentModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avaterUrl: avaterUrl ?? this.avaterUrl,
      relationship: relationship ?? this.relationship,
      residence: residense ?? this.residence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avaterUrl': avaterUrl,
      'relationship': relationship,
      'residense': residence,
    };
  }

  factory ParentModel.fromMap(Map<String, dynamic> map) {
    return ParentModel(
      id: map['id'] != null ? map['id'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      avaterUrl: map['avaterUrl'] != null ? map['avaterUrl'] as String : null,
      relationship:
          map['relationship'] != null ? map['relationship'] as String : null,
      residence: map['residense'] != null ? map['residense'] as String : null,
    );
  }
}
