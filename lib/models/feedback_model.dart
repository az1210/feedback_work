// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum FeedbackStatus {
  requested,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final String? id;
  final String projectId;
  final String projectOwnerId;
  final FeedbackStatus feedbackStatus;
  final FieldValue statusModifiedAt;
  final String givenByUserId;
  final bool isPrivate;
  final List<String> providersUId;
  final MessageModel message;
  final double cost;
  FeedbackModel({
    this.id,
    required this.projectId,
    required this.projectOwnerId,
    required this.feedbackStatus,
    required this.statusModifiedAt,
    required this.givenByUserId,
    required this.isPrivate,
    required this.providersUId,
    required this.message,
    required this.cost,
  });

  FeedbackModel copyWith({
    String? id,
    String? projectId,
    String? projectOwnerId,
    FeedbackStatus? feedbackStatus,
    FieldValue? statusModifiedAt,
    String? givenByUserId,
    bool? isPrivate,
    List<String>? providersUId,
    MessageModel? message,
    double? cost,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectOwnerId: projectOwnerId ?? this.projectOwnerId,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      statusModifiedAt: statusModifiedAt ?? this.statusModifiedAt,
      givenByUserId: givenByUserId ?? this.givenByUserId,
      isPrivate: isPrivate ?? this.isPrivate,
      providersUId: providersUId ?? this.providersUId,
      message: message ?? this.message,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'projectOwnerId': projectOwnerId,
      'feedbackStatus': feedbackStatus,
      'statusModifiedAt': statusModifiedAt,
      'givenByUserId': givenByUserId,
      'isPrivate': isPrivate,
      'providersUId': providersUId,
      'message': message.toMap(),
      'cost': cost,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] != null ? map['id'] as String : null,
      projectId: map['projectId'] as String,
      projectOwnerId: map['projectOwnerId'] as String,
      feedbackStatus: map['feedbackStatus'] as FeedbackStatus,
      statusModifiedAt: map['statusModifiedAt'] as FieldValue,
      givenByUserId: map['givenByUserId'] as String,
      isPrivate: map['isPrivate'] as bool,
      providersUId: List<String>.from(
        (map['providersUId'] as List<String>),
      ),
      message: MessageModel.fromMap(map['message'] as Map<String, dynamic>),
      cost: map['cost'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FeedbackModel(id: $id, projectId: $projectId, projectOwnerId: $projectOwnerId, feedbackStatus: $feedbackStatus, statusModifiedAt: $statusModifiedAt, givenByUserId: $givenByUserId, isPrivate: $isPrivate, providersUId: $providersUId, message: $message, cost: $cost)';
  }

  @override
  bool operator ==(covariant FeedbackModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.projectId == projectId &&
        other.projectOwnerId == projectOwnerId &&
        other.feedbackStatus == feedbackStatus &&
        other.statusModifiedAt == statusModifiedAt &&
        other.givenByUserId == givenByUserId &&
        other.isPrivate == isPrivate &&
        listEquals(other.providersUId, providersUId) &&
        other.message == message &&
        other.cost == cost;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        projectId.hashCode ^
        projectOwnerId.hashCode ^
        feedbackStatus.hashCode ^
        statusModifiedAt.hashCode ^
        givenByUserId.hashCode ^
        isPrivate.hashCode ^
        providersUId.hashCode ^
        message.hashCode ^
        cost.hashCode;
  }
}

class MessageModel {
  final String? subject;
  final String? message;
  final String? imageUrl;
  final String? ytUrl;
  MessageModel({
    this.subject,
    this.message,
    this.imageUrl,
    this.ytUrl,
  });

  MessageModel copyWith({
    String? subject,
    String? message,
    String? imageUrl,
    String? ytUrl,
  }) {
    return MessageModel(
      subject: subject ?? this.subject,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      ytUrl: ytUrl ?? this.ytUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'message': message,
      'imageUrl': imageUrl,
      'ytUrl': ytUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      subject: map['subject'] != null ? map['subject'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      ytUrl: map['ytUrl'] != null ? map['ytUrl'] as String : null,
    );
  }
}
