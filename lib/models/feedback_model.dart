// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';
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
  final RequestModel? requestFeedback;
  final ProvideModel? provideFeedback;
  final Status? feedbackStatus;
  FeedbackModel({
    this.id,
    this.project,
    this.projectOwnerId,
    this.requestFeedback,
    this.provideFeedback,
    this.feedbackStatus,
  });

  FeedbackModel copyWith({
    String? id,
    ProjectModel? project,
    String? projectOwnerId,
    RequestModel? requestFeedback,
    ProvideModel? provideFeedback,
    Status? feedbackStatus,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      project: project ?? this.project,
      projectOwnerId: projectOwnerId ?? this.projectOwnerId,
      requestFeedback: requestFeedback ?? this.requestFeedback,
      provideFeedback: provideFeedback ?? this.provideFeedback,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project': project?.toMap(),
      'projectOwnerId': projectOwnerId,
      'requestFeedback': requestFeedback?.toMap(),
      'provideFeedback': provideFeedback?.toMap(),
      'feedbackStatus': feedbackStatus?.toMap(),
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
      requestFeedback: map['requestFeedback'] != null
          ? RequestModel.fromMap(map['requestFeedback'] as Map<String, dynamic>)
          : null,
      provideFeedback: map['provideFeedback'] != null
          ? ProvideModel.fromMap(map['provideFeedback'] as Map<String, dynamic>)
          : null,
      feedbackStatus: map['feedbackStatus'] != null
          ? Status.fromMap(map['feedbackStatus'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RequestModel {
  final List<UserModel>? providers;
  final String? privacy;
  final MessageModel? message;
  final double? cost;
  final int? feedbackLimit;
  final bool? isAnnonymous;
  final String? groupId;
  RequestModel({
    this.providers,
    this.privacy,
    this.message,
    this.cost,
    this.feedbackLimit,
    this.isAnnonymous,
    this.groupId,
  });

  RequestModel copyWith({
    List<UserModel>? providers,
    String? privacy,
    MessageModel? message,
    double? cost,
    int? feedbackLimit,
    bool? isAnnonymous,
    String? groupId,
  }) {
    return RequestModel(
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
      'providers': providers?.map((x) => x.toMap()).toList(),
      'privacy': privacy,
      'message': message?.toMap(),
      'cost': cost,
      'feedbackLimit': feedbackLimit,
      'isAnnonymous': isAnnonymous,
      'groupId': groupId,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      providers: map['providers'] != null
          ? List<UserModel>.from(
              (map['providers']).map<UserModel>(
                (x) => UserModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      message: map['message'] != null
          ? MessageModel.fromMap(map['message'] as Map<String, dynamic>)
          : null,
      cost: map['cost'] != null ? map['cost'] as double : null,
      feedbackLimit:
          map['feedbackLimit'] != null ? map['feedbackLimit'] as int : null,
      isAnnonymous:
          map['isAnnonymous'] != null ? map['isAnnonymous'] as bool : null,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
    );
  }
}

class ProvideModel {
  final String? principle;
  final List<String>? principleToDeriveFrom;
  final List<PeopleInfoModel>? peoples;
  final Delta? principleDetails;
  final Delta? feedbackMessage;
  final String? feedbackFile;
  final bool? annonymous;
  ProvideModel({
    this.principle,
    this.principleToDeriveFrom,
    this.peoples,
    this.principleDetails,
    this.feedbackMessage,
    this.feedbackFile,
    this.annonymous,
  });

  ProvideModel copyWith({
    String? principle,
    List<String>? principleToDeriveFrom,
    List<PeopleInfoModel>? peoples,
    Delta? principleDetails,
    Delta? feedbackMessage,
    String? feedbackFile,
    bool? annonymous,
  }) {
    return ProvideModel(
      principle: principle ?? this.principle,
      principleToDeriveFrom:
          principleToDeriveFrom ?? this.principleToDeriveFrom,
      peoples: peoples ?? this.peoples,
      principleDetails: principleDetails ?? this.principleDetails,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      feedbackFile: feedbackFile ?? this.feedbackFile,
      annonymous: annonymous ?? this.annonymous,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'principle': principle,
      'principleToDeriveFrom': principleToDeriveFrom,
      'peoples': peoples?.map((x) => x.toMap()).toList(),
      'principleDetails': jsonEncode(principleDetails?.toJson()),
      'feedbackMessage': jsonEncode(feedbackMessage?.toJson()),
      'feedbackFile': feedbackFile,
      'annonymous': annonymous,
    };
  }

  factory ProvideModel.fromMap(Map<String, dynamic> map) {
    final principleDetails = (map['principleDetails'] == null)
        ? []
        : jsonDecode(map["principleDetails"]);
    final feedbackMessage = (map['feedbackMessage'] == null)
        ? []
        : jsonDecode(map["feedbackMessage"]);
    return ProvideModel(
      principle: map['principle'] != null ? map['principle'] as String : null,
      principleToDeriveFrom: map['principleToDeriveFrom'] != null
          ? List<String>.from(
              (map['principleToDeriveFrom']).map((x) => x.toString()))
          : null,
      peoples: map['peoples'] != null
          ? List<PeopleInfoModel>.from(
              (map['peoples']).map<PeopleInfoModel?>(
                (x) => PeopleInfoModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      principleDetails: Delta.fromJson(principleDetails),
      feedbackMessage: Delta.fromJson(feedbackMessage),
      feedbackFile:
          map['feedbackFile'] != null ? map['feedbackFile'] as String : null,
      annonymous: map['annonymous'] != null ? map['annonymous'] as bool : null,
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
