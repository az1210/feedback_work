import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:feedback_work/screens/feedback/widgets/preview_feedback_request.dart';
import 'package:feedback_work/screens/feedback/widgets/select_feedback_category.dart';
import 'package:feedback_work/screens/feedback/widgets/select_feedback_privacy.dart';
import 'package:feedback_work/screens/feedback/widgets/select_feedback_provider.dart';
import 'package:feedback_work/screens/feedback/widgets/type_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestFeedbackScreen extends ConsumerStatefulWidget {
  const RequestFeedbackScreen({super.key});

  @override
  ConsumerState<RequestFeedbackScreen> createState() =>
      _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends ConsumerState<RequestFeedbackScreen> {
  late PageController requestFeedbackController;

  final List<String> pageTitles = [
    "Select Feedback Category",
    "Select Privacy",
    "Select Feedback Provider",
    "Type Message",
    "Preview Feedback Request",
  ];

  @override
  void initState() {
    requestFeedbackController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    requestFeedbackController.dispose();
    super.dispose();
  }

  String? selectedCategory;

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
              controller: requestFeedbackController,
              children: [
                SelectFeedbackCategory(
                  onFiltersChanged: (p0) {
                    setState(() {
                      selectedCategory = p0["category"]?.first ?? "";
                    });
                  },
                ),
                const SelectFeedbackPrivacy(),
                SelectFeedbackProvider(
                  category: selectedCategory ?? "",
                ),
                const TypeMessage(),
                const PreviewFeedbackRequest(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            color: context.colors.pureWhite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.outlined(
                  horizontalPadding: 16.w,
                  width: 8.h,
                  label: ref.watch(requestFeedbackStepProvider) == 1
                      ? "Cancel"
                      : "Previous",
                  onTap: () {
                    if (ref.watch(requestFeedbackStepProvider) != 1) {
                      requestFeedbackController.previousPage(
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
                AppButton.filled(
                  horizontalPadding: 16.w,
                  width: 8.h,
                  label: ref.watch(requestFeedbackStepProvider) == 5
                      ? "Send Request"
                      : 'Next',
                  onTap: () {
                    requestFeedbackController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    ref.read(requestFeedbackStepProvider.notifier).state++;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
