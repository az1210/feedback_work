import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:feedback_work/models/project_model.dart';

enum FeedbackStatus {
  requested,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final ProjectModel project;
  final FeedbackStatus feedbackStatus;
  final FieldValue statusModifiedAt;
  final String? givenByUserId;
  FeedbackModel({
    required this.project,
    required this.feedbackStatus,
    required this.statusModifiedAt,
    this.givenByUserId,
  });

  FeedbackModel copyWith({
    ProjectModel? project,
    FeedbackStatus? feedbackStatus,
    FieldValue? statusModifiedAt,
    String? givenByUserId,
  }) {
    return FeedbackModel(
      project: project ?? this.project,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      statusModifiedAt: statusModifiedAt ?? this.statusModifiedAt,
      givenByUserId: givenByUserId ?? this.givenByUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'project': project.toMap(),
      'feedbackStatus': feedbackStatus,
      'statusModifiedAt': statusModifiedAt,
      'givenByUserId': givenByUserId,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      project: ProjectModel.fromMap(map['project'] as Map<String, dynamic>),
      feedbackStatus: map['feedbackStatus'] as FeedbackStatus,
      statusModifiedAt: map['statusModifiedAt'] as FieldValue,
      givenByUserId:
          map['givenByUserId'] != null ? map['givenByUserId'] as String : null,
    );
  }
}
