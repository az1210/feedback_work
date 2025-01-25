import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';

bool isOwnRequestedFeedback(
    {required FeedbackModel feedback, required String userId}) {
  return feedback.projectOwnerId == userId;
}

String feedbackStatus(
    {required FeedbackModel feedback, required String userId}) {
  if (feedback.projectOwnerId == userId) {
    switch (feedback.ownerSideStatus!.status) {
      case "Requested":
        return 'Requested';
      case "Received":
        return 'Received';
      case "Applied":
        return 'Applied';

      default:
        return 'Requested';
    }
  } else {
    switch (feedback.providerSideStatus!.status) {
      case "Providing":
        return 'Providing';
      case "Provided":
        return 'Provided';

      default:
        return 'Requested';
    }
  }
}

List<String?> extractUserIds(List<UserModel> users) {
  return users.map((user) => user.id).toList();
}
