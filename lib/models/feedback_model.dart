// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/utils/helper_functions.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';
import 'package:feedback_work/models/user_model.dart';

enum FeedbackStatus {
  requested,
  providing,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final String id;
  final ProjectModel? project;
  final String? projectOwnerId;
  final RequestModel? requestFeedback;
  final ProvideModel? provideFeedback;
  final AppliedModel? appliedFeedback;
  final Status? ownerSideStatus;
  final Status? providerSideStatus;
  final List<EcfModel>? errors;
  FeedbackModel({
    this.id = '',
    this.project,
    this.projectOwnerId = '',
    this.requestFeedback,
    this.provideFeedback,
    this.appliedFeedback,
    this.ownerSideStatus,
    this.providerSideStatus,
    this.errors,
  });

  FeedbackModel copyWith({
    String? id,
    ProjectModel? project,
    String? projectOwnerId,
    RequestModel? requestFeedback,
    ProvideModel? provideFeedback,
    AppliedModel? appliedFeedback,
    Status? ownerSideStatus,
    Status? providerSideStatus,
    List<EcfModel>? errors,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      project: project ?? this.project,
      projectOwnerId: projectOwnerId ?? this.projectOwnerId,
      requestFeedback: requestFeedback ?? this.requestFeedback,
      provideFeedback: provideFeedback ?? this.provideFeedback,
      appliedFeedback: appliedFeedback ?? this.appliedFeedback,
      ownerSideStatus: ownerSideStatus ?? this.ownerSideStatus,
      providerSideStatus: providerSideStatus ?? this.providerSideStatus,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project': project?.toMap(),
      'projectOwnerId': projectOwnerId,
      'requestFeedback': requestFeedback?.toMap(),
      'provideFeedback': provideFeedback?.toMap(),
      'appliedFeedback': appliedFeedback?.toMap(),
      'ownerSideStatus': ownerSideStatus?.toMap(),
      'providerSideStatus': providerSideStatus?.toMap(),
      'errors': errors?.map((e) => e.toMap()).toList(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] as String? ?? '',
      project: map['project'] != null
          ? ProjectModel.fromMap(map['project'] as Map<String, dynamic>)
          : null,
      projectOwnerId: map['projectOwnerId'] as String? ?? '',
      requestFeedback: map['requestFeedback'] != null
          ? RequestModel.fromMap(map['requestFeedback'] as Map<String, dynamic>)
          : null,
      provideFeedback: map['provideFeedback'] != null
          ? ProvideModel.fromMap(map['provideFeedback'] as Map<String, dynamic>)
          : null,
      appliedFeedback: map['appliedFeedback'] != null
          ? AppliedModel.fromMap(map['appliedFeedback'] as Map<String, dynamic>)
          : null,
      ownerSideStatus: map['ownerSideStatus'] != null
          ? Status.fromMap(map['ownerSideStatus'] as Map<String, dynamic>)
          : null,
      providerSideStatus: map['providerSideStatus'] != null
          ? Status.fromMap(map['providerSideStatus'] as Map<String, dynamic>)
          : null,
      errors: map['errors'] != null
          ? (map['errors'] as List<dynamic>)
              .map((e) => EcfModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class RequestModel {
  final String? provider;
  final List<String?>? selectedGroupMemberIds;
  final String? privacy;
  final MessageModel? message;
  final double? cost;
  final int? feedbackLimit;
  final bool? isAnnonymous;
  final String? groupId;
  RequestModel({
    this.provider,
    this.selectedGroupMemberIds = const [],
    this.privacy = '',
    this.message,
    this.cost = -1.0,
    this.feedbackLimit = -1,
    this.isAnnonymous = false,
    this.groupId = '',
  });

  RequestModel copyWith({
    String? provider,
    List<String?>? selectedGroupMemberIds,
    String? privacy,
    MessageModel? message,
    double? cost,
    int? feedbackLimit,
    bool? isAnnonymous,
    String? groupId,
  }) {
    return RequestModel(
      provider: provider ?? this.provider,
      selectedGroupMemberIds:
          selectedGroupMemberIds ?? this.selectedGroupMemberIds,
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
      'provider': provider,
      'selectedGroupMemberIds': selectedGroupMemberIds,
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
      provider: map['provider'] as String? ?? '',
      selectedGroupMemberIds: map['selectedGroupMemberIds'] != null
          ? List<String?>.from((map['selectedGroupMemberIds'] as List<dynamic>))
          : null,
      privacy: map['privacy'] as String? ?? '',
      message: MessageModel.fromMap(map['message'] as Map<String, dynamic>),
      cost: map['cost'] as double? ?? -1.0,
      feedbackLimit: map['feedbackLimit'] as int? ?? -1,
      isAnnonymous: map['isAnnonymous'] as bool,
      groupId: map['groupId'] as String? ?? '',
    );
  }
}

class ProvideModel {
  final String principle;
  final List<String>? principleToDeriveFrom;
  final List<PeopleInfoModel>? peoples;
  final Delta? principleDetails;
  final Delta? feedbackMessage;
  final String feedbackFile;
  final bool annonymous;
  ProvideModel({
    this.principle = '',
    this.principleToDeriveFrom = const [],
    this.peoples = const [],
    this.principleDetails,
    this.feedbackMessage,
    this.feedbackFile = '',
    this.annonymous = false,
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
      principle: map['principle'] as String? ?? '',
      principleToDeriveFrom: map['principleToDeriveFrom'] != null
          ? (map['principleToDeriveFrom'] as List<dynamic>)
              .map((x) => x.toString())
              .toList()
          : null,
      peoples: map['peoples'] != null
          ? (map['peoples'] as List<dynamic>)
              .map(
                (x) => PeopleInfoModel.fromMap(x as Map<String, dynamic>),
              )
              .toList()
          : null,
      principleDetails: Delta.fromJson(principleDetails),
      feedbackMessage: Delta.fromJson(feedbackMessage),
      feedbackFile: map['feedbackFile'] as String? ?? '',
      annonymous: map['annonymous'] as bool,
    );
  }
}

class EcfModel {
  final Delta? correctionMessage;
  EcfModel({
    this.correctionMessage,
  });

  EcfModel copyWith({
    Delta? correctionMessage,
  }) {
    return EcfModel(
      correctionMessage: correctionMessage ?? this.correctionMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'correctionMessage': jsonEncode(correctionMessage?.toJson()),
    };
  }

  factory EcfModel.fromMap(Map<String, dynamic> map) {
    return EcfModel(
      correctionMessage: map['correctionMessage'] != null
          ? Delta.fromJson(jsonDecode(map['correctionMessage']))
          : null,
    );
  }
}

class AppliedModel {
  final Delta? appliedMessage;
  final String? appliedFile;
  final bool? isHelpToSolve;
  AppliedModel({
    this.appliedMessage,
    this.appliedFile,
    this.isHelpToSolve,
  });

  AppliedModel copyWith({
    Delta? appliedMessage,
    String? appliedFile,
    bool? isHelpToSolve,
  }) {
    return AppliedModel(
      appliedMessage: appliedMessage ?? this.appliedMessage,
      appliedFile: appliedFile ?? this.appliedFile,
      isHelpToSolve: isHelpToSolve ?? this.isHelpToSolve,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appliedMessage': jsonEncode(appliedMessage?.toJson()),
      'appliedFile': appliedFile,
      'isHelpToSolve': isHelpToSolve,
    };
  }

  factory AppliedModel.fromMap(Map<String, dynamic> map) {
    final appliedMessage = (map['appliedMessage'] == null)
        ? []
        : jsonDecode(map["appliedMessage"]);
    return AppliedModel(
      appliedMessage: Delta.fromJson(appliedMessage),
      appliedFile:
          map['appliedFile'] != null ? map['appliedFile'] as String : null,
      isHelpToSolve:
          map['isHelpToSolve'] != null ? map['isHelpToSolve'] as bool : null,
    );
  }
}

class MessageModel {
  final String? subject;
  final Delta? message;
  final String? imageUrl;
  final String? ytUrl;
  MessageModel({
    this.subject = '',
    this.message,
    this.imageUrl = '',
    this.ytUrl = '',
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
      subject: map['subject'] as String? ?? '',
      message: Delta.fromJson(message),
      imageUrl: map['imageUrl'] as String? ?? '',
      ytUrl: map['ytUrl'] as String? ?? '',
    );
  }
}

class Status {
  final String? status;
  final String? modifiedAt;
  Status({
    this.status = '',
    this.modifiedAt = '',
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
      status: map['status'] as String? ?? '',
      modifiedAt: map['modifiedAt'] as String? ?? '',
    );
  }
}
