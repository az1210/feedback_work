import 'dart:convert';

import 'package:flutter_quill/quill_delta.dart';

import 'package:feedback_work/models/user_model.dart';

class ProjectModel {
  final String? id;
  final String title;
  final String? description;
  final String ownerId;
  final UserModel? owner;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String? startDateTime;
  final String? finishDateTime;
  final String? completionPercentage;
  final String? projectName;
  final String? problemName;
  final String? solutionName;
  final String? solutionFunctionName;

  ProjectModel({
    this.id,
    required this.title,
    this.description,
    required this.ownerId,
    this.owner,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.startDateTime,
    this.finishDateTime,
    this.completionPercentage,
    this.projectName,
    this.problemName,
    this.solutionName,
    this.solutionFunctionName,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    UserModel? owner,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? startDateTime,
    String? finishDateTime,
    String? completionPercentage,
    String? projectName,
    String? problemName,
    String? solutionName,
    String? solutionFunctionName,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDateTime: startDateTime ?? this.startDateTime,
      finishDateTime: finishDateTime ?? this.finishDateTime,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      projectName: projectName ?? this.projectName,
      problemName: problemName ?? this.problemName,
      solutionName: solutionName ?? this.solutionName,
      solutionFunctionName: solutionFunctionName ?? this.solutionFunctionName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'owner_id': ownerId,
      'owner': owner?.toMap(),
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'start_date_time': startDateTime,
      'finish_date_time': finishDateTime,
      'completion_percentage': completionPercentage,
      'project_name': projectName,
      'problem_name': problemName,
      'solution_name': solutionName,
      'solution_function_name': solutionFunctionName,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'],
      ownerId: map['owner_id'] ?? '',
      owner: map['owner'] != null ? UserModel.fromMap(map['owner']) : null,
      status: map['status'] ?? 'active',
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      startDateTime: map['start_date_time'],
      finishDateTime: map['finish_date_time'],
      completionPercentage: map['completion_percentage'],
      projectName: map['project_name'],
      problemName: map['problem_name'],
      solutionName: map['solution_name'],
      solutionFunctionName: map['solution_function_name'],
    );
  }
}

class ProjectTimelineModel {
  final String message;
  final String modifiedAt;
  final String? projectId;

  ProjectTimelineModel({
    required this.message,
    required this.modifiedAt,
    this.projectId,
  });

  ProjectTimelineModel copyWith({
    String? message,
    String? modifiedAt,
    String? projectId,
  }) {
    return ProjectTimelineModel(
      message: message ?? this.message,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      projectId: projectId ?? this.projectId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'modified_at': modifiedAt,
      'project_id': projectId,
    };
  }

  factory ProjectTimelineModel.fromMap(Map<String, dynamic> map) {
    return ProjectTimelineModel(
      message: map['message'] as String,
      modifiedAt: map['modified_at'] as String,
      projectId: map['project_id'] as String?,
    );
  }
}

class TimelineEvent {
  final String title;
  final String date;

  const TimelineEvent({
    required this.title,
    required this.date,
  });
}
