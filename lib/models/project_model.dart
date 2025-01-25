import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:flutter_quill/quill_delta.dart';

class ProjectModel {
  final String? id;
  final String? projectName;
  final String? problemName;
  final String? solutionName;
  final String? solutionFunctionName;
  final Delta? projectDescription;
  final String? youtubeLink;
  final String? imageUrl;
  final UserModel? owner;
  final String? ownerId;
  final String? createdAt;
  final String? startDateTime;
  final String? finishDateTime;
  final String? breakDateTime;
  final String? audioUrl;
  final String? popUpText;
  final double? completionPercentage;
  ProjectModel({
    this.id = '',
    this.projectName = '',
    this.problemName = '',
    this.solutionName = '',
    this.solutionFunctionName = '',
    this.projectDescription,
    this.youtubeLink = '',
    this.imageUrl = '',
    this.owner,
    this.ownerId = '',
    this.createdAt = '',
    this.startDateTime = '',
    this.finishDateTime = '',
    this.breakDateTime = '',
    this.audioUrl = '',
    this.popUpText = '',
    this.completionPercentage = -1.0,
  });

  ProjectModel copyWith({
    String? id,
    String? projectName,
    String? problemName,
    String? solutionName,
    String? solutionFunctionName,
    Delta? projectDescription,
    String? youtubeLink,
    String? imageUrl,
    UserModel? owner,
    String? ownerId,
    String? createdAt,
    String? startDateTime,
    String? finishDateTime,
    String? breakDateTime,
    String? audioUrl,
    String? popUpText,
    double? completionPercentage,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      problemName: problemName ?? this.problemName,
      solutionName: solutionName ?? this.solutionName,
      solutionFunctionName: solutionFunctionName ?? this.solutionFunctionName,
      projectDescription: projectDescription ?? this.projectDescription,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      imageUrl: imageUrl ?? this.imageUrl,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      startDateTime: startDateTime ?? this.startDateTime,
      finishDateTime: finishDateTime ?? this.finishDateTime,
      breakDateTime: breakDateTime ?? this.breakDateTime,
      audioUrl: audioUrl ?? this.audioUrl,
      popUpText: popUpText ?? this.popUpText,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectName': projectName,
      'problemName': problemName,
      'solutionName': solutionName,
      'solutionFunctionName': solutionFunctionName,
      'projectDescription': jsonEncode(projectDescription?.toJson()),
      'youtubeLink': youtubeLink,
      'imageUrl': imageUrl,
      'owner': owner?.toMap(),
      'ownerId': ownerId,
      'createdAt': DateTime.now().toString(),
      'startDateTime': startDateTime,
      'finishDateTime': finishDateTime,
      'breakDateTime': breakDateTime,
      'audioUrl': audioUrl,
      'popUpText': popUpText,
      'completionPercentage': completionPercentage,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    final projectDescription = (map['projectDescription'] == null)
        ? []
        : jsonDecode(map["projectDescription"]);
    return ProjectModel(
      id: map['id'] as String? ?? '',
      projectName: map['projectName'] as String? ?? '',
      problemName: map['problemName'] as String? ?? '',
      solutionName: map['solutionName'] as String? ?? '',
      solutionFunctionName: map['solutionFunctionName'] as String? ?? '',
      projectDescription: Delta.fromJson(projectDescription),
      youtubeLink: map['youtubeLink'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      owner: UserModel.fromMap(map['owner'] as Map<String, dynamic>),
      ownerId: map['ownerId'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      startDateTime: map['startDateTime'] as String? ?? '',
      finishDateTime: map['finishDateTime'] as String? ?? '',
      breakDateTime: map['breakDateTime'] as String? ?? '',
      audioUrl: map['audioUrl'] as String? ?? '',
      popUpText: map['popUpText'] as String? ?? '',
      completionPercentage: map['completionPercentage'] as double? ?? -1.0,
    );
  }
}
