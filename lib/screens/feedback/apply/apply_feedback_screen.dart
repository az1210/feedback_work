import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/assets/app_assets.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/network_image_helper.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/apply/widgets/feedback_applied_card.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/feedback_provided_content.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/model2_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';

class ApplyFeedbackScreen extends ConsumerStatefulWidget {
  const ApplyFeedbackScreen({required this.feedback, super.key});

  final FeedbackModel feedback;

  @override
  ConsumerState<ApplyFeedbackScreen> createState() =>
      _ProvidedFeedbackCardState();
}

class _ProvidedFeedbackCardState extends ConsumerState<ApplyFeedbackScreen> {
  quill.QuillController feedbackMessageController =
      quill.QuillController.basic();

  UserModel? provider;

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(fetchUserByIdProvider.notifier)
          .fetchUser(uid: widget.feedback.providerId!);
    });
    if (widget.feedback.provideFeedback != null) {
      if (widget.feedback.provideFeedback!.feedbackMessage != null) {
        feedbackMessageController.document = quill.Document.fromDelta(
            widget.feedback.provideFeedback!.feedbackMessage!);
      }
    }

    feedbackMessageController.readOnly = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(fetchUserByIdProvider);
    ref.listen(fetchUserByIdProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        provider = newState.data;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply Feedback"),
      ),
      body: Builder(builder: (context) {
        if (providerState.state == AsyncState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (providerState.error != null) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  16.ph,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: context.colors.pureWhite,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          color:
                              context.colors.primaryBlue.withValues(alpha: 0.1),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Feedback Received",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                  8.pw,
                                  if (widget.feedback.requestFeedback!.cost !=
                                      null) ...[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.r),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: context.colors.successGreen),
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        "\$${widget.feedback.requestFeedback!.cost}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 12,
                                              color:
                                                  context.colors.successGreen,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                DateTime.parse(widget.feedback.ownerSideStatus
                                            ?.modifiedAt ??
                                        DateTime.now().toString())
                                    .format("h:i A"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            children: [
                              16.ph,
                              StaggeredGrid.count(
                                crossAxisCount: 3,
                                children: [
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.r,
                                          backgroundColor:
                                              context.colors.background,
                                          child: Image.network(
                                            networkImage(provider?.avaterUrl),
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.person,
                                              color: context.colors.darkGrey,
                                              size: 30.r,
                                            ),
                                          ),
                                        ),
                                        8.ph,
                                        Text(
                                          "${provider?.firstName ?? ''} ${provider?.lastName ?? ''}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 1.3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Total Feedback Provided",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 14,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "${provider?.feedbackProvided ?? '0'}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: context
                                                        .colors.primaryBlue,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: context.colors.inputBorder,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Total Feedback Applied",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 14,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "${provider?.feedbackApplied ?? '0'}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: context
                                                        .colors.primaryBlue,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: context.colors.inputBorder,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Total Problem Solved",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 14,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${provider?.problemSolved ?? '0'}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: context
                                                        .colors.successGreen,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: context.colors.inputBorder,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Total Problems Help Solved",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontSize: 14,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${provider?.problemHelpSolved ?? '0'}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: context
                                                        .colors.successGreen,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.ph,
                      ],
                    ),
                  ),
                  16.ph,
                  FeedbackAppliedCard(feedback: widget.feedback),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
