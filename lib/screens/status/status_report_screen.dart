import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/providers/status_providers.dart';
import 'package:feedback_work/screens/status/widgets/after.dart';
import 'package:feedback_work/screens/status/widgets/before.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/widgets/app_button.dart';

class StatusReportScreen extends ConsumerStatefulWidget {
  const StatusReportScreen({super.key});

  @override
  ConsumerState<StatusReportScreen> createState() => _StatusReportScreenState();
}

class _StatusReportScreenState extends ConsumerState<StatusReportScreen> {
  late PageController statusReportController;

  final List<String> pageTitles = [
    "Before",
    "After",
  ];

  @override
  void initState() {
    statusReportController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    statusReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Status Report"),
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
                          value: ref.watch(statusReportStepProvider) / 2,
                          backgroundColor:
                              context.colors.darkGrey.withValues(alpha: 0.5),
                          color: context.colors.primaryBlue,
                        ),
                      ),
                      Text(
                        "${ref.watch(statusReportStepProvider).toInt()} of 2",
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
                          pageTitles[ref.watch(statusReportStepProvider) - 1],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ref.watch(statusReportStepProvider) == 2
                            ? const SizedBox.shrink()
                            : Text(
                                "Next: ${pageTitles[ref.watch(statusReportStepProvider)]}",
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
                controller: statusReportController,
                children: const [
                  Before(),
                  After(),
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
                    label: ref.watch(statusReportStepProvider) == 1
                        ? "Cancel"
                        : "Previous",
                    onTap: () {
                      if (ref.watch(statusReportStepProvider) != 1) {
                        statusReportController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        ref.read(statusReportStepProvider.notifier).state--;
                      } else {
                        context.pop();
                      }
                    },
                    borderColor: context.colors.primaryBlue,
                  ),
                  AppButton.filled(
                    horizontalPadding: 16.w,
                    width: 8.h,
                    label: ref.watch(statusReportStepProvider) == 2
                        ? "Send Request"
                        : 'Next',
                    onTap: () {
                      statusReportController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      ref.read(statusReportStepProvider.notifier).state++;
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
