// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedback_work/models/payment_model.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';

enum FeedbackStatus {
  requested,
  providing,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final String? id;
  final ProjectModel? project;
  final String? ownerId;
  final String? providerId;
  final RequestModel? requestFeedback;
  final ProvideModel? provideFeedback;
  final AppliedModel? appliedFeedback;
  final Status? ownerSideStatus;
  final Status? providerSideStatus;
  final StatusReport? statusReport;
  final String? paymentId;
  FeedbackModel({
    this.id,
    this.project,
    this.ownerId,
    this.providerId,
    this.requestFeedback,
    this.provideFeedback,
    this.appliedFeedback,
    this.ownerSideStatus,
    this.providerSideStatus,
    this.statusReport,
    this.paymentId,
  });

  FeedbackModel copyWith({
    String? id,
    ProjectModel? project,
    String? ownerId,
    String? providerId,
    RequestModel? requestFeedback,
    ProvideModel? provideFeedback,
    AppliedModel? appliedFeedback,
    Status? ownerSideStatus,
    Status? providerSideStatus,
    StatusReport? statusReport,
    String? paymentModel,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      project: project ?? this.project,
      ownerId: ownerId ?? this.ownerId,
      providerId: providerId ?? this.providerId,
      requestFeedback: requestFeedback ?? this.requestFeedback,
      provideFeedback: provideFeedback ?? this.provideFeedback,
      appliedFeedback: appliedFeedback ?? this.appliedFeedback,
      ownerSideStatus: ownerSideStatus ?? this.ownerSideStatus,
      providerSideStatus: providerSideStatus ?? this.providerSideStatus,
      statusReport: statusReport ?? this.statusReport,
      paymentId: paymentModel ?? paymentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project': project?.toMap(),
      'ownerId': ownerId,
      'providerId': providerId,
      'requestFeedback': requestFeedback?.toMap(),
      'provideFeedback': provideFeedback?.toMap(),
      'appliedFeedback': appliedFeedback?.toMap(),
      'ownerSideStatus': ownerSideStatus?.toMap(),
      'providerSideStatus': providerSideStatus?.toMap(),
      'statusReport': statusReport?.toMap(),
      'paymentId': paymentId,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] != null ? map['id'] as String : null,
      project: map['project'] != null
          ? ProjectModel.fromMap(map['project'] as Map<String, dynamic>)
          : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      providerId:
          map['providerId'] != null ? map['providerId'] as String : null,
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
      statusReport: map['statusReport'] != null
          ? StatusReport.fromMap(map['statusReport'] as Map<String, dynamic>)
          : null,
      paymentId: map['paymentId'] != null ? map['paymentId'] as String : null,
    );
  }
}

class RequestModel {
  final List<String?>? selectedGroupMemberIds;
  final String? privacy;
  final MessageModel? message;
  final double? cost;
  final int? feedbackLimit;
  final bool? isAnnonymous;
  final String? groupId;
  final String? requestedAt;
  RequestModel({
    this.selectedGroupMemberIds = const [],
    this.privacy = '',
    this.message,
    this.cost = -1.0,
    this.feedbackLimit = -1,
    this.isAnnonymous = false,
    this.groupId = '',
    this.requestedAt = '',
  });

  RequestModel copyWith({
    List<String?>? selectedGroupMemberIds,
    String? privacy,
    MessageModel? message,
    double? cost,
    int? feedbackLimit,
    bool? isAnnonymous,
    String? groupId,
    String? requestedAt,
  }) {
    return RequestModel(
      selectedGroupMemberIds:
          selectedGroupMemberIds ?? this.selectedGroupMemberIds,
      privacy: privacy ?? this.privacy,
      message: message ?? this.message,
      cost: cost ?? this.cost,
      feedbackLimit: feedbackLimit ?? this.feedbackLimit,
      isAnnonymous: isAnnonymous ?? this.isAnnonymous,
      groupId: groupId ?? this.groupId,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedGroupMemberIds': selectedGroupMemberIds,
      'privacy': privacy,
      'message': message?.toMap(),
      'cost': cost,
      'feedbackLimit': feedbackLimit,
      'isAnnonymous': isAnnonymous,
      'groupId': groupId,
      'requestedAt': requestedAt
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      selectedGroupMemberIds: map['selectedGroupMemberIds'] != null
          ? (map['selectedGroupMemberIds'] as List<dynamic>)
              .map((x) => x.toString())
              .toList()
          : null,
      privacy: map['privacy'] as String? ?? '',
      message: MessageModel.fromMap(map['message'] as Map<String, dynamic>),
      cost: map['cost'] as double? ?? -1.0,
      feedbackLimit: map['feedbackLimit'] as int? ?? -1,
      isAnnonymous: map['isAnnonymous'] as bool,
      groupId: map['groupId'] as String? ?? '',
      requestedAt: map['requestedAt'] as String? ?? '',
    );
  }
}

class ProvideModel {
  final String principle;
  final List<String>? principleToDeriveFrom;
  final ProvideInfoModel? provideInfo;
  final Delta? principleDetails;
  final Delta? feedbackMessage;
  final String feedbackFile;
  final bool annonymous;
  final String? providedAt;
  ProvideModel({
    this.principle = '',
    this.principleToDeriveFrom = const [],
    this.provideInfo,
    this.principleDetails,
    this.feedbackMessage,
    this.feedbackFile = '',
    this.annonymous = false,
    this.providedAt = '',
  });

  ProvideModel copyWith({
    String? principle,
    List<String>? principleToDeriveFrom,
    ProvideInfoModel? people,
    Delta? principleDetails,
    Delta? feedbackMessage,
    String? feedbackFile,
    bool? annonymous,
    String? providedAt,
  }) {
    return ProvideModel(
      principle: principle ?? this.principle,
      principleToDeriveFrom:
          principleToDeriveFrom ?? this.principleToDeriveFrom,
      provideInfo: people ?? provideInfo,
      principleDetails: principleDetails ?? this.principleDetails,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      feedbackFile: feedbackFile ?? this.feedbackFile,
      annonymous: annonymous ?? this.annonymous,
      providedAt: providedAt ?? this.providedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'principle': principle,
      'principleToDeriveFrom': principleToDeriveFrom,
      'provideInfo': provideInfo?.toMap(),
      'principleDetails': jsonEncode(principleDetails?.toJson()),
      'feedbackMessage': jsonEncode(feedbackMessage?.toJson()),
      'feedbackFile': feedbackFile,
      'annonymous': annonymous,
      'providedAt': providedAt,
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
      provideInfo: map['provideInfo'] != null
          ? ProvideInfoModel.fromMap(map['provideInfo'] as Map<String, dynamic>)
          : null,
      principleDetails: Delta.fromJson(principleDetails),
      feedbackMessage: Delta.fromJson(feedbackMessage),
      feedbackFile: map['feedbackFile'] as String? ?? '',
      annonymous: map['annonymous'] as bool,
      providedAt: map['providedAt'] as String? ?? "",
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
  final String? appliedAt;
  AppliedModel({
    this.appliedMessage,
    this.appliedFile,
    this.isHelpToSolve,
    this.appliedAt,
  });

  AppliedModel copyWith({
    Delta? appliedMessage,
    String? appliedFile,
    bool? isHelpToSolve,
    String? appliedAt,
  }) {
    return AppliedModel(
      appliedMessage: appliedMessage ?? this.appliedMessage,
      appliedFile: appliedFile ?? this.appliedFile,
      isHelpToSolve: isHelpToSolve ?? this.isHelpToSolve,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appliedMessage': jsonEncode(appliedMessage?.toJson()),
      'appliedFile': appliedFile,
      'isHelpToSolve': isHelpToSolve,
      'appliedAt': appliedAt,
    };
  }

  factory AppliedModel.fromMap(Map<String, dynamic> map) {
    final appliedMessage = (map['appliedMessage'] == null)
        ? []
        : jsonDecode(map["appliedMessage"]);
    return AppliedModel(
        appliedMessage: Delta.fromJson(appliedMessage),
        appliedFile: map['appliedFile'] as String? ?? '',
        isHelpToSolve: map['isHelpToSolve'] as bool? ?? false,
        appliedAt: map['appliedAt'] as String? ?? '');
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

class StatusReport {
  final String? beforeFileUrl;
  final String? beforeYtLink;
  final String? afterFileUrl;
  final String? afterYtLink;
  StatusReport({
    this.beforeFileUrl,
    this.beforeYtLink,
    this.afterFileUrl,
    this.afterYtLink,
  });

  StatusReport copyWith({
    String? beforeFileUrl,
    String? beforeYtLink,
    String? afterFileUrl,
    String? afterYtLink,
  }) {
    return StatusReport(
      beforeFileUrl: beforeFileUrl ?? this.beforeFileUrl,
      beforeYtLink: beforeYtLink ?? this.beforeYtLink,
      afterFileUrl: afterFileUrl ?? this.afterFileUrl,
      afterYtLink: afterYtLink ?? this.afterYtLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'beforeFileUrl': beforeFileUrl,
      'beforeYtLink': beforeYtLink,
      'afterFileUrl': afterFileUrl,
      'afterYtLink': afterYtLink,
    };
  }

  factory StatusReport.fromMap(Map<String, dynamic> map) {
    return StatusReport(
      beforeFileUrl:
          map['beforeFileUrl'] != null ? map['beforeFileUrl'] as String : null,
      beforeYtLink:
          map['beforeYtLink'] != null ? map['beforeYtLink'] as String : null,
      afterFileUrl:
          map['afterFileUrl'] != null ? map['afterFileUrl'] as String : null,
      afterYtLink:
          map['afterYtLink'] != null ? map['afterYtLink'] as String : null,
    );
  }
}
