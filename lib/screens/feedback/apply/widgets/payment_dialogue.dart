import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentDialogue extends ConsumerWidget {
  final FeedbackModel feedback;

  const PaymentDialogue({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apply Feedback',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "By accepting or applying this feedback, you are going to pay ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\$${feedback.requestFeedback!.cost} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: "for the effort of ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text:
                        "who provides you the feedback. The money will be deducted from your account to provide ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        "${feedback.project!.owner!.firstName} ${feedback.project!.owner!.lastName} ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: "who provided you the feedback.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton.outlined(
                    label: "Cancel",
                    onTap: () {
                      context.pop();
                    },
                    borderColor: context.colors.primaryBlue,
                  ),
                ),
                16.pw,
                Expanded(
                  child: AppButton.filled(
                    label: "Confirm Payment",
                    onTap: () {
                      ref.read(feedbackProvider.notifier).appliedFeedback(
                            feedback: feedback,
                            userId: feedback.projectOwnerId!,
                            callback: () {
                              context.goNamed(Routes.feedback);
                            },
                          );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
