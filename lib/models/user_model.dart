import 'dart:convert';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String avaterUrl;
  final String phoneNumber;
  final String title;
  final String expertise;
  final String accountType;
  final String createdAt;
  final double minimumRate;
  final int feedbackProvided;
  final int feedbackApplied;
  final int problemSolved;
  final int problemHelpSolved;
  final double totalEarned;
  final double totalSpent;
  final int totalFeedbackProvidedForFree;
  final int totalFeedbackAccepted;
  final int totalFeedbackDeclined;

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
    this.totalEarned = -1,
    this.totalSpent = -1,
    this.totalFeedbackProvidedForFree = -1,
    this.totalFeedbackAccepted = -1,
    this.totalFeedbackDeclined = -1,
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
    double? totalEarned,
    double? totalSpent,
    int? totalFeedbackProvidedForFree,
    int? totalFeedbackAccepted,
    int? totalFeedbackDeclined,
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
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      totalFeedbackProvidedForFree:
          totalFeedbackProvidedForFree ?? this.totalFeedbackProvidedForFree,
      totalFeedbackAccepted:
          totalFeedbackAccepted ?? this.totalFeedbackAccepted,
      totalFeedbackDeclined:
          totalFeedbackDeclined ?? this.totalFeedbackDeclined,
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
      'createdAt': createdAt,
      'minimumRate': minimumRate,
      'feedbackProvided': feedbackProvided,
      'feedbackApplied': feedbackApplied,
      'problemSolved': problemSolved,
      'problemHelpSolved': problemHelpSolved,
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'totalFeedbackProvidedForFree': totalFeedbackProvidedForFree,
      'totalFeedbackAccepted': totalFeedbackAccepted,
      'totalFeedbackDeclined': totalFeedbackDeclined,
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
      createdAt: map['createdAt'] as String? ?? '',
      minimumRate: map['minimumRate'] as double? ?? -1.0,
      feedbackProvided: map['feedbackProvided'] as int? ?? -1,
      feedbackApplied: map['feedbackApplied'] as int? ?? -1,
      problemSolved: map['problemSolved'] as int? ?? -1,
      problemHelpSolved: map['problemHelpSolved'] as int? ?? -1,
      totalEarned: map['totalEarned'] as double? ?? -1,
      totalSpent: map['totalSpent'] as double? ?? -1,
      totalFeedbackProvidedForFree:
          map['totalFeedbackProvidedForFree'] as int? ?? -1,
      totalFeedbackAccepted: map['totalFeedbackAccepted'] as int? ?? -1,
      totalFeedbackDeclined: map['totalFeedbackDeclined'] as int? ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, username: $username, avaterUrl: $avaterUrl, phoneNumber: $phoneNumber, title: $title, expertise: $expertise, accountType: $accountType, createdAt: $createdAt, minimumRate: $minimumRate, feedbackProvided: $feedbackProvided, feedbackApplied: $feedbackApplied, problemSolved: $problemSolved, problemHelpSolved: $problemHelpSolved)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.username == username &&
        other.avaterUrl == avaterUrl &&
        other.phoneNumber == phoneNumber &&
        other.title == title &&
        other.expertise == expertise &&
        other.accountType == accountType &&
        other.createdAt == createdAt &&
        other.minimumRate == minimumRate &&
        other.feedbackProvided == feedbackProvided &&
        other.feedbackApplied == feedbackApplied &&
        other.problemSolved == problemSolved &&
        other.problemHelpSolved == problemHelpSolved &&
        other.totalEarned == totalEarned &&
        other.totalSpent == totalSpent &&
        other.totalFeedbackProvidedForFree == totalFeedbackProvidedForFree &&
        other.totalFeedbackAccepted == totalFeedbackAccepted &&
        other.totalFeedbackDeclined == totalFeedbackDeclined;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        username.hashCode ^
        avaterUrl.hashCode ^
        phoneNumber.hashCode ^
        title.hashCode ^
        expertise.hashCode ^
        accountType.hashCode ^
        createdAt.hashCode ^
        minimumRate.hashCode ^
        feedbackProvided.hashCode ^
        feedbackApplied.hashCode ^
        problemSolved.hashCode ^
        problemHelpSolved.hashCode ^
        totalEarned.hashCode ^
        totalSpent.hashCode ^
        totalFeedbackProvidedForFree.hashCode ^
        totalFeedbackAccepted.hashCode ^
        totalFeedbackDeclined.hashCode;
  }
}
