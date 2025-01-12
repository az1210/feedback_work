import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? avaterUrl;
  final String? phoneNumber;
  final String? title;
  final String? expertise;
  final String? accountType;
  final FieldValue? createdAt;
  final double? minimumRate;
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.avaterUrl,
    this.phoneNumber,
    this.title,
    this.expertise,
    this.accountType,
    this.createdAt,
    this.minimumRate,
  });

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? avaterUrl,
    String? phoneNumber,
    String? title,
    String? expertise,
    String? accountType,
    FieldValue? createdAt,
    double? minimumRate,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      avaterUrl: avaterUrl ?? this.avaterUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      title: title ?? this.title,
      expertise: expertise ?? this.expertise,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      minimumRate: minimumRate ?? this.minimumRate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'avaterUrl': avaterUrl,
      'phoneNumber': phoneNumber,
      'title': title,
      'expertise': expertise,
      'accountType': accountType,
      'createdAt': FieldValue.serverTimestamp(),
      'minimumRate': minimumRate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      avaterUrl: map['avaterUrl'] != null ? map['avaterUrl'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      expertise: map['expertise'] != null ? map['expertise'] as String : null,
      accountType:
          map['accountType'] != null ? map['accountType'] as String : null,
      minimumRate:
          map['minimumRate'] != null ? map['minimumRate'] as double : null,
    );
  }
}
