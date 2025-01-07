import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String? projectName;
  final String? problemName;
  final String? solutionName;
  final String? solutionFunctionName;
  final String? projectDescription;
  final String? youtubeLink;
  final String? imageUrl;
  final FieldValue? createdAt;
  final String? creatorId;
  final CreatorDetailsModel creatorDetails;
  ProjectModel({
    this.projectName,
    this.problemName,
    this.solutionName,
    this.solutionFunctionName,
    this.projectDescription,
    this.youtubeLink,
    this.imageUrl,
    this.createdAt,
    this.creatorId,
    required this.creatorDetails,
  });

  ProjectModel copyWith({
    String? projectName,
    String? problemName,
    String? solutionName,
    String? solutionFunctionName,
    String? projectDescription,
    String? youtubeLink,
    String? imageUrl,
    FieldValue? createdAt,
    String? creatorId,
    CreatorDetailsModel? creatorDetails,
  }) {
    return ProjectModel(
      projectName: projectName ?? this.projectName,
      problemName: problemName ?? this.problemName,
      solutionName: solutionName ?? this.solutionName,
      solutionFunctionName: solutionFunctionName ?? this.solutionFunctionName,
      projectDescription: projectDescription ?? this.projectDescription,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      creatorId: creatorId ?? this.creatorId,
      creatorDetails: creatorDetails ?? this.creatorDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectName': projectName,
      'problemName': problemName,
      'solutionName': solutionName,
      'solutionFunctionName': solutionFunctionName,
      'projectDescription': projectDescription,
      'youtubeLink': youtubeLink,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'creatorId': creatorId,
      'creatorDetails': creatorDetails.toMap(),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
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
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as FieldValue : null,
      creatorId: map['creatorId'] != null ? map['creatorId'] as String : null,
      creatorDetails: CreatorDetailsModel.fromMap(
          map['creatorDetails'] as Map<String, dynamic>),
    );
  }
}

class CreatorDetailsModel {
  final String? username;
  final String? title;
  final String? expertise;
  CreatorDetailsModel({
    this.username,
    this.title,
    this.expertise,
  });

  CreatorDetailsModel copyWith({
    String? username,
    String? title,
    String? expertise,
  }) {
    return CreatorDetailsModel(
      username: username ?? this.username,
      title: title ?? this.title,
      expertise: expertise ?? this.expertise,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'title': title,
      'expertise': expertise,
    };
  }

  factory CreatorDetailsModel.fromMap(Map<String, dynamic> map) {
    return CreatorDetailsModel(
      username: map['username'] != null ? map['username'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      expertise: map['expertise'] != null ? map['expertise'] as String : null,
    );
  }
}
