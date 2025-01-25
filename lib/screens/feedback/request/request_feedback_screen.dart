import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/extensions/string_extension.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/project_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:feedback_work/screens/feedback/request/widgets/define_price.dart';
import 'package:feedback_work/screens/feedback/request/widgets/preview_feedback_request.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_category.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_privacy.dart';
import 'package:feedback_work/screens/feedback/request/widgets/select_feedback_provider.dart';
import 'package:feedback_work/screens/feedback/request/widgets/type_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class RequestFeedbackScreen extends ConsumerStatefulWidget {
  const RequestFeedbackScreen({required this.project, super.key});

  final ProjectModel project;

  @override
  ConsumerState<RequestFeedbackScreen> createState() =>
      _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends ConsumerState<RequestFeedbackScreen> {
  late PageController requestFeedbackController;

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController problemNameController = TextEditingController();
  final TextEditingController solutionNameController = TextEditingController();
  final TextEditingController solutionFunctionController =
      TextEditingController();
  final TextEditingController youtubeLinkController = TextEditingController();
  final quill.QuillController messageController = quill.QuillController.basic();

  String? selectedUser;
  List<String?>? selectedGrpupUserIds;
  UserModel? currentUser;
  String? subject;
  String? youtubeLink;
  String? feedbackCost;
  bool isAnnonymous = false;
  String? selectedCategory;
  String selectedPrivacy = '';
  String? feedbackLimit;
  // String currentUserId = '';
  String? selectedGroupId;

  final List<String> pageTitles = [
    "Select Feedback Category",
    "Select Privacy",
    "Define Price",
    "Select Feedback Provider",
    "Type Message",
    "Preview Feedback Request",
  ];

  @override
  void initState() {
    Log.info(widget.project.toMap().toString());
    requestFeedbackController = PageController();
    Future.microtask(() async {
      currentUser = await ref.watch(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  void dispose() {
    projectNameController.dispose();
    problemNameController.dispose();
    solutionNameController.dispose();
    solutionFunctionController.dispose();
    youtubeLinkController.dispose();
    requestFeedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // currentUserId = ref.read(firebaseAuthProvider).currentUser!.uid;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(requestFeedbackStepProvider.notifier).state = 1;
      },
      child: Scaffold(
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
                          pageTitles[
                              ref.watch(requestFeedbackStepProvider) - 1],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ref.watch(requestFeedbackStepProvider) == 6
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
                        selectedCategory = p0;
                      });
                    },
                  ),
                  SelectFeedbackPrivacy(
                    onSelectPrivacy: (p0) {
                      setState(() {
                        selectedPrivacy = p0!;
                      });
                    },
                    onChangeAnnonymous: (p0) {
                      setState(() {
                        isAnnonymous = p0!;
                      });
                    },
                    onChangeFeedbackLimit: (p0) {
                      setState(() {
                        feedbackLimit = p0;
                      });
                    },
                  ),
                  DefinePrice(
                    onDefinePrice: (p0) {
                      setState(() {
                        feedbackCost = p0;
                      });
                    },
                  ),
                  SelectFeedbackProvider(
                    category: selectedCategory ?? "",
                    selectedIndividualUser: (p0) {
                      setState(() {
                        selectedUser = p0;
                        selectedGroupId = '';
                      });
                    },
                    selectedGroupId: (p0) {
                      setState(() {
                        selectedGroupId = p0;
                      });
                    },
                    selectedGroupUsers: (p0) {
                      setState(() {
                        selectedGrpupUserIds = p0;
                      });
                    },
                    currentUserId: currentUser?.id ?? '',
                  ),
                  TypeMessage(
                    message: messageController,
                    subject: (p0) {
                      setState(() {
                        subject = p0;
                      });
                    },
                    youtubeLink: (p0) {
                      setState(() {
                        youtubeLink = p0;
                      });
                    },
                  ),
                  PreviewFeedbackRequest(
                    feedback: FeedbackModel(
                      project: widget.project,
                      projectOwnerId: widget.project.ownerId,
                      requestFeedback: RequestModel(
                        provider: selectedUser,
                        selectedGroupMemberIds: selectedGrpupUserIds ?? [],
                        privacy: selectedPrivacy,
                        message: MessageModel(
                          subject: subject,
                          message: messageController.document.toDelta(),
                          ytUrl: youtubeLink,
                        ),
                        cost: double.tryParse(
                              feedbackCost ?? '0',
                            ) ??
                            0,
                        feedbackLimit: int.tryParse(feedbackLimit ?? "1") ?? 1,
                        groupId: selectedGroupId ?? '',
                        isAnnonymous: isAnnonymous,
                      ),
                    ),
                  ),
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
                          requestFeedbackController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          ref
                              .read(requestFeedbackStepProvider.notifier)
                              .state--;
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
                      label: ref.watch(requestFeedbackStepProvider) == 6
                          ? "Send Request"
                          : 'Next',
                      onTap: ref.watch(requestFeedbackStepProvider) == 6
                          ? () {
                              final feedback = FeedbackModel(
                                requestFeedback: RequestModel(
                                  provider: selectedUser,
                                  isAnnonymous: isAnnonymous,
                                  message: MessageModel(
                                    message:
                                        messageController.document.toDelta(),
                                    subject: subject,
                                    ytUrl: youtubeLink,
                                  ),
                                  cost:
                                      double.tryParse(feedbackCost ?? "0") ?? 0,
                                  feedbackLimit:
                                      int.tryParse(feedbackLimit ?? "0") ?? 0,
                                  privacy: selectedPrivacy,
                                  groupId: selectedGroupId ?? '',
                                  selectedGroupMemberIds: selectedGrpupUserIds,
                                ),
                                project: widget.project,
                                projectOwnerId: widget.project.ownerId!,
                              );

                              Log.info(feedback.toMap().toString());
                              ref
                                  .read(feedbackProvider.notifier)
                                  .createFeedbackRequest(
                                    feedback: feedback,
                                    userId: currentUser!.id!,
                                    callback: () {
                                      context.pop();
                                    },
                                  );
                            }
                          : () {
                              requestFeedbackController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              ref
                                  .read(requestFeedbackStepProvider.notifier)
                                  .state++;
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
