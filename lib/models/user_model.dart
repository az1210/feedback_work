// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? title;
  final String? expertise;
  final String? accountType;
  final DateTime? createdAt;
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
    this.avatarUrl,
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

  // Factory constructor to create UserModel from Supabase User
  factory UserModel.fromSupabaseUser(User user,
      [Map<String, dynamic>? extraData]) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.userMetadata?['firstName'] ?? extraData?['firstName'],
      lastName: user.userMetadata?['lastName'] ?? extraData?['lastName'],
      username: user.userMetadata?['username'] ?? extraData?['username'],
      avatarUrl: user.userMetadata?['avatarUrl'] ?? extraData?['avatarUrl'],
      createdAt: DateTime.parse(user.createdAt),
      // Other fields from extraData if available
      phoneNumber: extraData?['phoneNumber'],
      title: extraData?['title'],
      expertise: extraData?['expertise'],
      accountType: extraData?['accountType'],
      minimumRate: extraData?['minimumRate']?.toDouble(),
      feedbackProvided: extraData?['feedbackProvided'],
      feedbackApplied: extraData?['feedbackApplied'],
      problemSolved: extraData?['problemSolved'],
      problemHelpSolved: extraData?['problemHelpSolved'],
      totalEarned: extraData?['totalEarned']?.toDouble(),
      totalSpent: extraData?['totalSpent']?.toDouble(),
      totalFeedbackRequested: extraData?['totalFeedbackRequested'],
      totalFeedbackReceived: extraData?['totalFeedbackReceived'],
      totalFeedbackProvidedForFree: extraData?['totalFeedbackProvidedForFree'],
      totalFeedbackAccepted: extraData?['totalFeedbackAccepted'],
      totalFeedbackDeclined: extraData?['totalFeedbackDeclined'],
      totalFeedbackAcceptedAmount:
          extraData?['totalFeedbackAcceptedAmount']?.toDouble(),
      totalFeedbackProvidedAtCostAmount:
          extraData?['totalFeedbackProvidedAtCostAmount']?.toDouble(),
      totalFeedbackProvidedFreeAmount:
          extraData?['totalFeedbackProvidedFreeAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'title': title,
      'expertise': expertise,
      'account_type': accountType,
      'created_at': createdAt?.toIso8601String(),
      'minimum_rate': minimumRate,
      'feedback_provided': feedbackProvided,
      'feedback_applied': feedbackApplied,
      'problem_solved': problemSolved,
      'problem_help_solved': problemHelpSolved,
      'total_earned': totalEarned,
      'total_spent': totalSpent,
      'total_feedback_requested': totalFeedbackRequested,
      'total_feedback_received': totalFeedbackReceived,
      'total_feedback_provided_for_free': totalFeedbackProvidedForFree,
      'total_feedback_accepted': totalFeedbackAccepted,
      'total_feedback_declined': totalFeedbackDeclined,
      'total_feedback_accepted_amount': totalFeedbackAcceptedAmount,
      'total_feedback_provided_at_cost_amount':
          totalFeedbackProvidedAtCostAmount,
      'total_feedback_provided_free_amount': totalFeedbackProvidedFreeAmount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      firstName: map['first_name']?.toString(),
      lastName: map['last_name']?.toString(),
      email: map['email']?.toString(),
      username: map['username']?.toString(),
      avatarUrl: map['avatar_url']?.toString(),
      phoneNumber: map['phone_number']?.toString(),
      title: map['title']?.toString(),
      expertise: map['expertise']?.toString(),
      accountType: map['account_type']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
      minimumRate: map['minimum_rate']?.toDouble(),
      feedbackProvided: map['feedback_provided']?.toInt(),
      feedbackApplied: map['feedback_applied']?.toInt(),
      problemSolved: map['problem_solved']?.toInt(),
      problemHelpSolved: map['problem_help_solved']?.toInt(),
      totalEarned: map['total_earned']?.toDouble(),
      totalSpent: map['total_spent']?.toDouble(),
      totalFeedbackRequested: map['total_feedback_requested']?.toInt(),
      totalFeedbackReceived: map['total_feedback_received']?.toInt(),
      totalFeedbackProvidedForFree:
          map['total_feedback_provided_for_free']?.toInt(),
      totalFeedbackAccepted: map['total_feedback_accepted']?.toInt(),
      totalFeedbackDeclined: map['total_feedback_declined']?.toInt(),
      totalFeedbackAcceptedAmount:
          map['total_feedback_accepted_amount']?.toDouble(),
      totalFeedbackProvidedAtCostAmount:
          map['total_feedback_provided_at_cost_amount']?.toDouble(),
      totalFeedbackProvidedFreeAmount:
          map['total_feedback_provided_free_amount']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? avatarUrl,
    String? phoneNumber,
    String? title,
    String? expertise,
    String? accountType,
    DateTime? createdAt,
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
      avatarUrl: avatarUrl ?? this.avatarUrl,
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

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, username: $username, avatarUrl: $avatarUrl, phoneNumber: $phoneNumber, title: $title, expertise: $expertise, accountType: $accountType, createdAt: $createdAt, minimumRate: $minimumRate, feedbackProvided: $feedbackProvided, feedbackApplied: $feedbackApplied, problemSolved: $problemSolved, problemHelpSolved: $problemHelpSolved, totalEarned: $totalEarned, totalSpent: $totalSpent, totalFeedbackRequested: $totalFeedbackRequested, totalFeedbackReceived: $totalFeedbackReceived, totalFeedbackProvidedForFree: $totalFeedbackProvidedForFree, totalFeedbackAccepted: $totalFeedbackAccepted, totalFeedbackDeclined: $totalFeedbackDeclined, totalFeedbackAcceptedAmount: $totalFeedbackAcceptedAmount, totalFeedbackProvidedAtCostAmount: $totalFeedbackProvidedAtCostAmount, totalFeedbackProvidedFreeAmount: $totalFeedbackProvidedFreeAmount)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.username == username &&
        other.avatarUrl == avatarUrl &&
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
        avatarUrl.hashCode ^
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
