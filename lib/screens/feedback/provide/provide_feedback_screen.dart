import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/add_people_details.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/feedback_model.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/select_principle.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/select_principle_to_derive.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/type_principle.dart';
import 'package:feedback_work/screens/feedback/request/widgets/preview_feedback_request.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_category.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_privacy.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_provider.dart';
import 'package:feedback_work/screens/feedback/request/widgets/type_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProvideFeedbackScreen extends ConsumerStatefulWidget {
  const ProvideFeedbackScreen({super.key});

  @override
  ConsumerState<ProvideFeedbackScreen> createState() =>
      _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends ConsumerState<ProvideFeedbackScreen> {
  late PageController provideFeedbackController;

  final List<String> pageTitles = [
    "Select Principle",
    "Select Principle to Derive From",
    "Add People details",
    "Type Principle",
    "Feedback Model",
  ];

  @override
  void initState() {
    provideFeedbackController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    provideFeedbackController.dispose();
    super.dispose();
  }

  String? selectedPrinciple;
  List<String>? selectedPrinciples;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Feedback"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 50.r,
                      width: 50.r,
                      child: CircularProgressIndicator(
                        value: ref.watch(requestFeedbackStepProvider) / 6,
                        backgroundColor:
                            context.colors.darkGrey.withValues(alpha: 0.5),
                        color: context.colors.primaryBlue,
                      ),
                    ),
                    Text(
                      "${ref.watch(requestFeedbackStepProvider).toInt()} of 6",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pageTitles[ref.watch(requestFeedbackStepProvider) - 1],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ref.watch(requestFeedbackStepProvider) == 5
                          ? const SizedBox.shrink()
                          : Text(
                              "Next: ${pageTitles[ref.watch(requestFeedbackStepProvider)]}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: provideFeedbackController,
              children: const [
                SelectPrinciple(),
                SelectPrincipleToDerive(),
                AddPeopleDetails(),
                TypePrinciple(),
                FeedbackModel(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            color: context.colors.pureWhite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton.outlined(
                    horizontalPadding: 16.w,
                    width: 8.h,
                    label: ref.watch(requestFeedbackStepProvider) == 1
                        ? "Cancel"
                        : "Previous",
                    onTap: () {
                      if (ref.watch(requestFeedbackStepProvider) != 1) {
                        provideFeedbackController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        ref.read(requestFeedbackStepProvider.notifier).state--;
                      } else {
                        context.pop();
                      }
                    },
                    borderColor: context.colors.primaryBlue,
                  ),
                ),
                32.pw,
                Expanded(
                  child: AppButton.filled(
                    horizontalPadding: 16.w,
                    width: 8.h,
                    label: ref.watch(requestFeedbackStepProvider) == 5
                        ? "Send Request"
                        : 'Next',
                    onTap: () {
                      provideFeedbackController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      ref.read(requestFeedbackStepProvider.notifier).state++;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
