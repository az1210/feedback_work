// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';

enum FeedbackStatus {
  requested,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final String? id;
  final ProjectModel? project;
  final String? projectOwnerId;
  final List<Status>? feedbackStatus;
  final List<UserModel> providers;
  final String? privacy;
  final MessageModel message;
  final double? cost;
  final int? feedbackLimit;
  final bool? isAnnonymous;
  final String? groupId;
  FeedbackModel({
    this.id,
    this.project,
    this.projectOwnerId,
    this.feedbackStatus,
    required this.providers,
    this.privacy,
    required this.message,
    this.cost,
    this.feedbackLimit,
    this.isAnnonymous,
    this.groupId,
  });

  FeedbackModel copyWith({
    String? id,
    ProjectModel? project,
    String? projectOwnerId,
    List<Status>? feedbackStatus,
    List<UserModel>? providers,
    String? privacy,
    MessageModel? message,
    double? cost,
    int? feedbackLimit,
    bool? isAnnonymous,
    String? groupId,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      project: project ?? this.project,
      projectOwnerId: projectOwnerId ?? this.projectOwnerId,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      providers: providers ?? this.providers,
      privacy: privacy ?? this.privacy,
      message: message ?? this.message,
      cost: cost ?? this.cost,
      feedbackLimit: feedbackLimit ?? this.feedbackLimit,
      isAnnonymous: isAnnonymous ?? this.isAnnonymous,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project': project?.toMap(),
      'projectOwnerId': projectOwnerId,
      'feedbackStatus': feedbackStatus?.map((x) => x.toMap()).toList(),
      'providers': providers.map((x) => x.toMap()).toList(),
      'privacy': privacy,
      'message': message.toMap(),
      'cost': cost,
      'feedbackLimit': feedbackLimit,
      'isAnnonymous': isAnnonymous,
      'groupId': groupId,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] != null ? map['id'] as String : null,
      project: map['project'] != null
          ? ProjectModel.fromMap(map['project'] as Map<String, dynamic>)
          : null,
      projectOwnerId: map['projectOwnerId'] != null
          ? map['projectOwnerId'] as String
          : null,
      feedbackStatus: map['feedbackStatus'] != null
          ? List<Status>.from(
              (map['feedbackStatus'] as List<dynamic>).map<Status?>(
                (x) => Status.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      providers: List<UserModel>.from(
        (map['providers'] as List<dynamic>).map<UserModel>(
          (x) => UserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      message: MessageModel.fromMap(map['message'] as Map<String, dynamic>),
      cost: map['cost'] != null ? map['cost'] as double : null,
      feedbackLimit:
          map['feedbackLimit'] != null ? map['feedbackLimit'] as int : null,
      isAnnonymous:
          map['isAnnonymous'] != null ? map['isAnnonymous'] as bool : null,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
    );
  }
}

class MessageModel {
  final String? subject;
  final Delta? message;
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
    Delta? message,
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
      'message': jsonEncode(message?.toJson()),
      'imageUrl': imageUrl,
      'ytUrl': ytUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final message = (map['message'] == null) ? [] : jsonDecode(map["message"]);
    return MessageModel(
      subject: map['subject'] != null ? map['subject'] as String : null,
      message: Delta.fromJson(message),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      ytUrl: map['ytUrl'] != null ? map['ytUrl'] as String : null,
    );
  }
}

class Status {
  final String? status;
  final String? modifiedAt;
  Status({
    this.status,
    this.modifiedAt,
  });

  Status copyWith({
    String? status,
    String? modifiedAt,
  }) {
    return Status(
      status: status ?? this.status,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'modifiedAt': DateTime.now().toString(),
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      status: map['status'] as String,
      modifiedAt: map['modifiedAt'] as String,
    );
  }
}
