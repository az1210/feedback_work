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
  final String? createdAt;
  final double? minimumRate;
  final int? feedbackProvided;
  final int? feedbackApplied;
  final int? problemSolved;
  final int? problemHelpSolved;

  UserModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.username = '',
    this.avaterUrl = '',
    this.phoneNumber = '',
    this.title = '',
    this.expertise = '',
    this.accountType = '',
    this.createdAt = '',
    this.minimumRate = -1.0,
    this.feedbackProvided = -1,
    this.feedbackApplied = -1,
    this.problemSolved = -1,
    this.problemHelpSolved = -1,
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
    String? createdAt,
    double? minimumRate,
    int? feedbackProvided,
    int? feedbackApplied,
    int? problemSolved,
    int? problemHelpSolved,
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
      feedbackProvided: feedbackProvided ?? this.feedbackProvided,
      feedbackApplied: feedbackApplied ?? this.feedbackApplied,
      problemSolved: problemSolved ?? this.problemSolved,
      problemHelpSolved: problemHelpSolved ?? this.problemHelpSolved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'avaterUrl': avaterUrl,
      'phoneNumber': phoneNumber,
      'title': title,
      'expertise': expertise,
      'accountType': accountType,
      'createdAt': DateTime.now().toString(),
      'minimumRate': minimumRate,
      'feedbackProvided': feedbackProvided,
      'feedbackApplied': feedbackApplied,
      'problemSolved': problemSolved,
      'problemHelpSolved': problemHelpSolved,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
      avaterUrl: map['avaterUrl'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      title: map['title'] as String? ?? '',
      expertise: map['expertise'] as String? ?? '',
      accountType: map['accountType'] as String? ?? '',
      // createdAt: map['createdAt'] as String? ?? '',
      minimumRate: map['minimumRate'] as double? ?? -1.0,
      feedbackProvided: map['feedbackProvided'] as int? ?? -1,
      feedbackApplied: map['feedbackApplied'] as int? ?? -1,
      problemSolved: map['problemSolved'] as int? ?? -1,
      problemHelpSolved: map['problemHelpSolved'] as int? ?? -1,
    );
  }
}
