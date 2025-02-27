// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  final double? totalEarned;
  final double? totalSpent;
  final int? totalFeedbackRequested;
  final int? totalFeedbackReceived;
  final int? totalFeedbackProvidedForFree;
  final int? totalFeedbackAccepted;
  final int? totalFeedbackDeclined;
  final double? totalFeedbackAcceptedAmount;
  final double? totalFeedbackProvidedAtCostAmount;
  final double? totalFeedbackProvidedFreeAmount;
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
    this.totalEarned,
    this.totalSpent,
    this.totalFeedbackRequested,
    this.totalFeedbackReceived,
    this.totalFeedbackProvidedForFree,
    this.totalFeedbackAccepted,
    this.totalFeedbackDeclined,
    this.totalFeedbackAcceptedAmount,
    this.totalFeedbackProvidedAtCostAmount,
    this.totalFeedbackProvidedFreeAmount,
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
    int? totalFeedbackRequested,
    int? totalFeedbackReceived,
    int? totalFeedbackProvidedForFree,
    int? totalFeedbackAccepted,
    int? totalFeedbackDeclined,
    double? totalFeedbackAcceptedAmount,
    double? totalFeedbackProvidedAtCostAmount,
    double? totalFeedbackProvidedFreeAmount,
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
      totalFeedbackRequested:
          totalFeedbackRequested ?? this.totalFeedbackRequested,
      totalFeedbackReceived:
          totalFeedbackReceived ?? this.totalFeedbackReceived,
      totalFeedbackProvidedForFree:
          totalFeedbackProvidedForFree ?? this.totalFeedbackProvidedForFree,
      totalFeedbackAccepted:
          totalFeedbackAccepted ?? this.totalFeedbackAccepted,
      totalFeedbackDeclined:
          totalFeedbackDeclined ?? this.totalFeedbackDeclined,
      totalFeedbackAcceptedAmount:
          totalFeedbackAcceptedAmount ?? this.totalFeedbackAcceptedAmount,
      totalFeedbackProvidedAtCostAmount: totalFeedbackProvidedAtCostAmount ??
          this.totalFeedbackProvidedAtCostAmount,
      totalFeedbackProvidedFreeAmount: totalFeedbackProvidedFreeAmount ??
          this.totalFeedbackProvidedFreeAmount,
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
      'totalFeedbackRequested': totalFeedbackRequested,
      'totalFeedbackReceived': totalFeedbackReceived,
      'totalFeedbackProvidedForFree': totalFeedbackProvidedForFree,
      'totalFeedbackAccepted': totalFeedbackAccepted,
      'totalFeedbackDeclined': totalFeedbackDeclined,
      'totalFeedbackAcceptedAmount': totalFeedbackAcceptedAmount,
      'totalFeedbackProvidedAtCostAmount': totalFeedbackProvidedAtCostAmount,
      'totalFeedbackProvidedFreeAmount': totalFeedbackProvidedFreeAmount,
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
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
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
      totalEarned:
          map['totalEarned'] != null ? map['totalEarned'] as double : null,
      totalSpent:
          map['totalSpent'] != null ? map['totalSpent'] as double : null,
      totalFeedbackRequested: map['totalFeedbackRequested'] != null
          ? map['totalFeedbackRequested'] as int
          : null,
      totalFeedbackReceived: map['totalFeedbackReceived'] != null
          ? map['totalFeedbackReceived'] as int
          : null,
      totalFeedbackProvidedForFree: map['totalFeedbackProvidedForFree'] != null
          ? map['totalFeedbackProvidedForFree'] as int
          : null,
      totalFeedbackAccepted: map['totalFeedbackAccepted'] != null
          ? map['totalFeedbackAccepted'] as int
          : null,
      totalFeedbackDeclined: map['totalFeedbackDeclined'] != null
          ? map['totalFeedbackDeclined'] as int
          : null,
      totalFeedbackAcceptedAmount: map['totalFeedbackAcceptedAmount'] != null
          ? map['totalFeedbackAcceptedAmount'] as double
          : null,
      totalFeedbackProvidedAtCostAmount:
          map['totalFeedbackProvidedAtCostAmount'] != null
              ? map['totalFeedbackProvidedAtCostAmount'] as double
              : null,
      totalFeedbackProvidedFreeAmount:
          map['totalFeedbackProvidedFreeAmount'] != null
              ? map['totalFeedbackProvidedFreeAmount'] as double
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, username: $username, avaterUrl: $avaterUrl, phoneNumber: $phoneNumber, title: $title, expertise: $expertise, accountType: $accountType, createdAt: $createdAt, minimumRate: $minimumRate, feedbackProvided: $feedbackProvided, feedbackApplied: $feedbackApplied, problemSolved: $problemSolved, problemHelpSolved: $problemHelpSolved, totalEarned: $totalEarned, totalSpent: $totalSpent, totalFeedbackRequested: $totalFeedbackRequested, totalFeedbackReceived: $totalFeedbackReceived, totalFeedbackProvidedForFree: $totalFeedbackProvidedForFree, totalFeedbackAccepted: $totalFeedbackAccepted, totalFeedbackDeclined: $totalFeedbackDeclined, totalFeedbackAcceptedAmount: $totalFeedbackAcceptedAmount, totalFeedbackProvidedAtCostAmount: $totalFeedbackProvidedAtCostAmount, totalFeedbackProvidedFreeAmount: $totalFeedbackProvidedFreeAmount)';
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
        other.totalFeedbackRequested == totalFeedbackRequested &&
        other.totalFeedbackReceived == totalFeedbackReceived &&
        other.totalFeedbackProvidedForFree == totalFeedbackProvidedForFree &&
        other.totalFeedbackAccepted == totalFeedbackAccepted &&
        other.totalFeedbackDeclined == totalFeedbackDeclined &&
        other.totalFeedbackAcceptedAmount == totalFeedbackAcceptedAmount &&
        other.totalFeedbackProvidedAtCostAmount ==
            totalFeedbackProvidedAtCostAmount &&
        other.totalFeedbackProvidedFreeAmount ==
            totalFeedbackProvidedFreeAmount;
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
        totalFeedbackRequested.hashCode ^
        totalFeedbackReceived.hashCode ^
        totalFeedbackProvidedForFree.hashCode ^
        totalFeedbackAccepted.hashCode ^
        totalFeedbackDeclined.hashCode ^
        totalFeedbackAcceptedAmount.hashCode ^
        totalFeedbackProvidedAtCostAmount.hashCode ^
        totalFeedbackProvidedFreeAmount.hashCode;
  }
}
