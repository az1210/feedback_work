import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/feedback_model.dart';
import 'package:feedback_work/models/provide_feedback_people_model.dart';
import 'package:feedback_work/providers/category_providers.dart';
import 'package:feedback_work/providers/feedback_providers.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/add_people_details.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/set_feedback_model.dart';
import 'package:feedback_work/screens/feedback/provide/preview_set_screen.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/select_principle.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/select_principle_to_derive.dart';
import 'package:feedback_work/screens/feedback/provide/widgets/type_principle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ProvideFeedbackScreen extends ConsumerStatefulWidget {
  const ProvideFeedbackScreen({required this.feedbackModel, super.key});

  final FeedbackModel feedbackModel;

  @override
  ConsumerState<ProvideFeedbackScreen> createState() =>
      _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends ConsumerState<ProvideFeedbackScreen> {
  final quill.QuillController principleDetailsController =
      quill.QuillController.basic();
  final FocusNode principleDetailsFocusNode = FocusNode();

  late PageController provideFeedbackController;

  final List<String> pageTitles = [
    "Select Principle",
    "Select Principle to Derive From",
    "Add People details",
    "Type Principle",
    "Feedback Model",
  ];

  String selectedPrinciple = '';
  String selectedModel = '';
  List<String> selectedPrinciplesToDeriveForm = [];
  List<PeopleInfoModel> peopleInfo = [];

  @override
  void initState() {
    provideFeedbackController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    principleDetailsController.dispose();
    provideFeedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Provide Feedback"),
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
                        value: ref.watch(provideFeedbackStepProvider) / 5,
                        backgroundColor:
                            context.colors.darkGrey.withValues(alpha: 0.5),
                        color: context.colors.primaryBlue,
                      ),
                    ),
                    Text(
                      "${ref.watch(provideFeedbackStepProvider)} of 5",
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
                        pageTitles[ref.watch(provideFeedbackStepProvider) - 1],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ref.watch(provideFeedbackStepProvider) == 5
                          ? const SizedBox.shrink()
                          : Text(
                              "Next: ${pageTitles[ref.watch(provideFeedbackStepProvider)]}",
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
              children: [
                SelectPrinciple(
                  onSelectPrinciple: (p0) {
                    setState(() {
                      selectedPrinciple = p0;
                    });
                  },
                ),
                SelectPrincipleToDerive(
                  selectedPrinciples: (p0) {
                    setState(() {
                      selectedPrinciplesToDeriveForm = p0;
                    });
                  },
                ),
                AddPeopleDetails(
                  peoples: peopleInfo,
                ),
                TypePrinciple(
                  controller: principleDetailsController,
                  focusNode: principleDetailsFocusNode,
                ),
                SetFeedbackModel(
                  principle: selectedPrinciple,
                  principlesToDeriveForm: selectedPrinciplesToDeriveForm,
                  onSelectModel: (p0) {
                    setState(() {
                      selectedModel = p0;
                    });
                  },
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
                    label: ref.watch(provideFeedbackStepProvider) == 1
                        ? "Cancel"
                        : "Previous",
                    onTap: () {
                      if (ref.watch(provideFeedbackStepProvider) != 1) {
                        provideFeedbackController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        ref.read(provideFeedbackStepProvider.notifier).state--;
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
                    label: ref.watch(provideFeedbackStepProvider) == 5
                        ? "Preview Feedback"
                        : 'Next',
                    onTap: ref.watch(provideFeedbackStepProvider) == 5
                        ? () {
                            final providedFeedback =
                                widget.feedbackModel.copyWith(
                                    provideFeedback: ProvideModel(
                              peoples: peopleInfo,
                              principle: selectedPrinciple,
                              principleDetails:
                                  principleDetailsController.document.toDelta(),
                              principleToDeriveFrom:
                                  selectedPrinciplesToDeriveForm,
                            ));
                            context.pushNamed(
                              Routes.previewSet,
                              extra: providedFeedback,
                            );
                          }
                        : () {
                            Log.info(provideFeedbackController.page.toString());
                            Log.info(ref
                                .watch(provideFeedbackStepProvider)
                                .toString());
                            provideFeedbackController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            ref
                                .read(provideFeedbackStepProvider.notifier)
                                .state++;
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
