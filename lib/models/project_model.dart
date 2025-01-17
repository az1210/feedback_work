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
  final dynamic createdAt;
  final dynamic startDateTime;
  final dynamic finishDateTime;
  final dynamic breakDateTime;
  final String? audioUrl;
  final String? popUpText;
  final double? completionPercentage;
  ProjectModel({
    this.id,
    this.projectName,
    this.problemName,
    this.solutionName,
    this.solutionFunctionName,
    this.projectDescription,
    this.youtubeLink,
    this.imageUrl,
    this.owner,
    this.ownerId,
    this.createdAt,
    this.startDateTime,
    this.finishDateTime,
    this.breakDateTime,
    this.audioUrl,
    this.popUpText,
    this.completionPercentage,
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
    dynamic createdAt,
    dynamic startDateTime,
    dynamic finishDateTime,
    dynamic breakDateTime,
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
      'createdAt': FieldValue.serverTimestamp(),
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
      id: map['id'] != null ? map['id'] as String : null,
      projectName:
          map['projectName'] != null ? map['projectName'] as String : null,
      problemName:
          map['problemName'] != null ? map['problemName'] as String : null,
      solutionName:
          map['solutionName'] != null ? map['solutionName'] as String : null,
      solutionFunctionName: map['solutionFunctionName'] != null
          ? map['solutionFunctionName'] as String
          : null,
      projectDescription: Delta.fromJson(projectDescription),
      youtubeLink:
          map['youtubeLink'] != null ? map['youtubeLink'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      owner: map['owner'] != null
          ? UserModel.fromMap(map['owner'] as Map<String, dynamic>)
          : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      createdAt: map['createdAt'] as dynamic,
      startDateTime: map['startDateTime'] as dynamic,
      finishDateTime: map['finishDateTime'] as dynamic,
      breakDateTime: map['breakDateTime'] as dynamic,
      audioUrl: map['audioUrl'] != null ? map['audioUrl'] as String : null,
      popUpText: map['popUpText'] != null ? map['popUpText'] as String : null,
      completionPercentage: map['completionPercentage'] != null
          ? map['completionPercentage'] as double
          : null,
    );
  }
}
