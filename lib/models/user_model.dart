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
    this.feedbackProvided,
    this.feedbackApplied,
    this.problemSolved,
    this.problemHelpSolved,
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
      // createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      minimumRate:
          map['minimumRate'] != null ? map['minimumRate'] as double : null,
      feedbackProvided: map['feedbackProvided'] != null
          ? map['feedbackProvided'] as int
          : null,
      feedbackApplied:
          map['feedbackApplied'] != null ? map['feedbackApplied'] as int : null,
      problemSolved:
          map['problemSolved'] != null ? map['problemSolved'] as int : null,
      problemHelpSolved: map['problemHelpSolved'] != null
          ? map['problemHelpSolved'] as int
          : null,
    );
  }
}
