import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';

bool isOwnRequestedFeedback(
    {required FeedbackModel feedback, required String userId}) {
  return feedback.ownerId == userId;
}

String feedbackStatus(
    {required FeedbackModel feedback, required String userId}) {
  if (feedback.ownerId == userId) {
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
      case "Requested":
        return 'Requested';
      case "Provided":
        return 'Provided';

      default:
        return 'Provided';
    }
  }
}

List<String?> extractUserIds(List<UserModel> users) {
  return users.map((user) => user.id).toList();
}
