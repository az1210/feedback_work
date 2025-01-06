import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final String? title;
  final String? expertise;
  final String? accountType;
  final FieldValue? createdAt;
  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.title,
    this.expertise,
    this.accountType,
    this.createdAt,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? phoneNumber,
    String? title,
    String? expertise,
    String? accountType,
    FieldValue? createdAt,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      title: title ?? this.title,
      expertise: expertise ?? this.expertise,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'title': title,
      'expertise': expertise,
      'accountType': accountType,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      expertise: map['expertise'] != null ? map['expertise'] as String : null,
      accountType:
          map['accountType'] != null ? map['accountType'] as String : null,
    );
  }
}
