import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String? id;
  final String? projectName;
  final String? problemName;
  final String? solutionName;
  final String? solutionFunctionName;
  final String? projectDescription;
  final String? youtubeLink;
  final String? imageUrl;
  final String? creatorId;
  final FieldValue? startDateTime;
  final FieldValue? finishDateTime;
  final FieldValue? breakDateTime;
  final String? audioUrl;
  final String? popUpText;
  ProjectModel({
    this.id,
    this.projectName,
    this.problemName,
    this.solutionName,
    this.solutionFunctionName,
    this.projectDescription,
    this.youtubeLink,
    this.imageUrl,
    this.creatorId,
    this.startDateTime,
    this.finishDateTime,
    this.breakDateTime,
    this.audioUrl,
    this.popUpText,
  });

  ProjectModel copyWith({
    String? id,
    String? projectName,
    String? problemName,
    String? solutionName,
    String? solutionFunctionName,
    String? projectDescription,
    String? youtubeLink,
    String? imageUrl,
    String? creatorId,
    FieldValue? startDateTime,
    FieldValue? finishDateTime,
    FieldValue? breakDateTime,
    String? audioUrl,
    String? popUpText,
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
      creatorId: creatorId ?? this.creatorId,
      startDateTime: startDateTime ?? this.startDateTime,
      finishDateTime: finishDateTime ?? this.finishDateTime,
      breakDateTime: breakDateTime ?? this.breakDateTime,
      audioUrl: audioUrl ?? this.audioUrl,
      popUpText: popUpText ?? this.popUpText,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectName': projectName,
      'problemName': problemName,
      'solutionName': solutionName,
      'solutionFunctionName': solutionFunctionName,
      'projectDescription': projectDescription,
      'youtubeLink': youtubeLink,
      'imageUrl': imageUrl,
      'creatorId': creatorId,
      'startDateTime': startDateTime,
      'finishDateTime': finishDateTime,
      'breakDateTime': breakDateTime,
      'audioUrl': audioUrl,
      'popUpText': popUpText,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
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
      projectDescription: map['projectDescription'] != null
          ? map['projectDescription'] as String
          : null,
      youtubeLink:
          map['youtubeLink'] != null ? map['youtubeLink'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      creatorId: map['creatorId'] != null ? map['creatorId'] as String : null,
      startDateTime: map['startDateTime'] != null
          ? map['startDateTime'] as FieldValue
          : null,
      finishDateTime: map['finishDateTime'] != null
          ? map['finishDateTime'] as FieldValue
          : null,
      breakDateTime: map['breakDateTime'] != null
          ? map['breakDateTime'] as FieldValue
          : null,
      audioUrl: map['audioUrl'] != null ? map['audioUrl'] as String : null,
      popUpText: map['popUpText'] != null ? map['popUpText'] as String : null,
    );
  }
}

class ProgressModel {
  final String? projectStatus;
  final FieldValue? modifiedAt;
  ProgressModel({
    this.projectStatus,
    this.modifiedAt,
  });

  ProgressModel copyWith({
    String? projectStatus,
    FieldValue? modifiedAt,
  }) {
    return ProgressModel(
      projectStatus: projectStatus ?? this.projectStatus,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectStatus': projectStatus,
      'modifiedAt': modifiedAt,
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      projectStatus:
          map['projectStatus'] != null ? map['projectStatus'] as String : null,
      modifiedAt:
          map['modifiedAt'] != null ? map['modifiedAt'] as FieldValue : null,
    );
  }
}
