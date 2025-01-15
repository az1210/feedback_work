import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_work/models/user_model.dart';

enum FeedbackStatus {
  requested,
  received,
  applied,
  provided,
}

class FeedbackModel {
  final String? id;
  final String? projectId;
  final String? projectOwnerId;
  final Status? feedbackStatus;
  final String? givenByUserId;
  final List<UserModel> givenToUsers;
  final bool isPrivate;
  final MessageModel message;
  final double cost;
  FeedbackModel({
    this.id,
    this.projectId,
    this.projectOwnerId,
    this.feedbackStatus,
    this.givenByUserId,
    required this.givenToUsers,
    required this.isPrivate,
    required this.message,
    required this.cost,
  });

  FeedbackModel copyWith({
    String? id,
    String? projectId,
    String? projectOwnerId,
    Status? feedbackStatus,
    String? givenByUserId,
    List<UserModel>? givenToUsers,
    bool? isPrivate,
    MessageModel? message,
    double? cost,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectOwnerId: projectOwnerId ?? this.projectOwnerId,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      givenByUserId: givenByUserId ?? this.givenByUserId,
      givenToUsers: givenToUsers ?? this.givenToUsers,
      isPrivate: isPrivate ?? this.isPrivate,
      message: message ?? this.message,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'projectOwnerId': projectOwnerId,
      'feedbackStatus': feedbackStatus?.toMap(),
      'givenByUserId': givenByUserId,
      'givenToUsers': givenToUsers.map((x) => x.toMap()).toList(),
      'isPrivate': isPrivate,
      'message': message.toMap(),
      'cost': cost,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] != null ? map['id'] as String : null,
      projectId: map['projectId'] != null ? map['projectId'] as String : null,
      projectOwnerId: map['projectOwnerId'] != null
          ? map['projectOwnerId'] as String
          : null,
      feedbackStatus: map['feedbackStatus'] != null
          ? Status.fromMap(map['feedbackStatus'] as Map<String, dynamic>)
          : null,
      givenByUserId:
          map['givenByUserId'] != null ? map['givenByUserId'] as String : null,
      givenToUsers: List<UserModel>.from(
        (map['givenToUsers'] as List<dynamic>).map<UserModel>(
          (x) => UserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      isPrivate: map['isPrivate'] as bool,
      message: MessageModel.fromMap(map['message'] as Map<String, dynamic>),
      cost: map['cost'] as double,
    );
  }
}

class MessageModel {
  final String? subject;
  final String? message;
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
    String? message,
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
      'message': message,
      'imageUrl': imageUrl,
      'ytUrl': ytUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      subject: map['subject'] != null ? map['subject'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      ytUrl: map['ytUrl'] != null ? map['ytUrl'] as String : null,
    );
  }
}

class Status {
  final String status;
  final FieldValue modifiedAt;
  Status({
    required this.status,
    required this.modifiedAt,
  });

  Status copyWith({
    String? status,
    FieldValue? modifiedAt,
  }) {
    return Status(
      status: status ?? this.status,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'modifiedAt': modifiedAt,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      status: map['status'] as String,
      modifiedAt: map['modifiedAt'] as FieldValue,
    );
  }
}
