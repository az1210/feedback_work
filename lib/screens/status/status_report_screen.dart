import 'package:date_time_format/date_time_format.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/utils/toast_message.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StatusReportScreen extends ConsumerStatefulWidget {
  const StatusReportScreen({super.key, required this.feedback});
  final FeedbackModel feedback;
  @override
  ConsumerState<StatusReportScreen> createState() => _StatusReportScreenState();
}

class _StatusReportScreenState extends ConsumerState<StatusReportScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    Future.microtask(() async {
      currentUser = await ref.watch(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Report'),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.feedback.projectOwnerId != currentUser!.id) {
                context.pushNamed(Routes.editStatusReport,
                    extra: widget.feedback);
              } else {
                showToast(message: "You can't edit the status report");
              }
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              16.ph,
              Text(
                "Before",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              8.ph,
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.errorRed,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.feedback.statusReport?.beforeFileUrl ?? ''),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Problem",
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    16.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                context.colors.pureWhite.withValues(alpha: 0.8),
                            border: Border.all(
                              color: context.colors.errorRed,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            widget.feedback.project!.problemName ??
                                'Unknown problem',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color: context.colors.errorRed,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              16.ph,
              Text(
                "After",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              8.ph,
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.successGreen,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.feedback.statusReport?.afterFileUrl ?? ''),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Solution",
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    16.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                context.colors.pureWhite.withValues(alpha: 0.8),
                            border: Border.all(
                              color: context.colors.successGreen,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            widget.feedback.project!.solutionName ??
                                'Unknown problem',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  color: context.colors.successGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              16.ph,
              Text(
                widget.feedback.project!.solutionName ?? 'Unknown problem',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: context.colors.successGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Project Status ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text:
                          '${widget.feedback.project!.completionPercentage == -1 ? 0 : widget.feedback.project!.completionPercentage}% Completed',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: context.colors.primaryBlue,
                          ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Start Date ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: DateTime.tryParse(
                                  widget.feedback.project!.startDateTime ?? '')
                              ?.format('d/m/Y, hA') ??
                          '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'End Date ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: DateTime.tryParse(
                                  widget.feedback.project!.finishDateTime ?? '')
                              ?.format('d/m/Y, hA') ??
                          '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Duration ',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: DateTimeFormat.relative(
                          DateTime.tryParse(
                                  widget.feedback.project!.finishDateTime ??
                                      '') ??
                              DateTime.now(),
                          relativeTo: DateTime.tryParse(
                              widget.feedback.project!.finishDateTime ?? '')),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              16.ph,
            ],
          ),
        ),
      ),
    );
  }
}
