class ParentModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avaterUrl;
  final String? relationship;
  final String? residence;
  ParentModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.avaterUrl = '',
    this.relationship = '',
    this.residence = '',
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
      residence: residense ?? residence,
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
      id: map['id'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avaterUrl: map['avaterUrl'] as String? ?? '',
      relationship: map['relationship'] as String? ?? '',
      residence: map['residense'] as String? ?? '',
    );
  }
}
