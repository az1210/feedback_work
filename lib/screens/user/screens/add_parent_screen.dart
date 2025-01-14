import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/models/parent_model.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/parent_providers.dart';
import 'package:feedback_work/screens/user/widgets/select_parent.dart';
import 'package:feedback_work/screens/user/widgets/select_relationship_with_children.dart';
import 'package:feedback_work/screens/user/widgets/select_residence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddParentScreen extends ConsumerStatefulWidget {
  const AddParentScreen({required this.currentUserId, super.key});

  final String currentUserId;
  @override
  ConsumerState<AddParentScreen> createState() => _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends ConsumerState<AddParentScreen> {
  late PageController addParentController;

  final List<String> pageTitles = [
    "Select Parent",
    "Relationship with Children",
    "Select Residence",
  ];

  UserModel? selectedUser;
  String? selectedRelationship;
  String? selectedResidence;

  @override
  void initState() {
    addParentController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    addParentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add parent"),
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
                        value: ref.watch(addParentStepProvider) / 3,
                        backgroundColor:
                            context.colors.darkGrey.withValues(alpha: 0.5),
                        color: context.colors.primaryBlue,
                      ),
                    ),
                    Text(
                      "${ref.watch(addParentStepProvider).toInt()} of 3",
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
                        pageTitles[ref.watch(addParentStepProvider) - 1],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ref.watch(addParentStepProvider) == 3
                          ? const SizedBox.shrink()
                          : Text(
                              "Next: ${pageTitles[ref.watch(addParentStepProvider)]}",
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
              controller: addParentController,
              children: [
                SelectParent(
                  onFiltersChanged: (selectedFilters) {
                    setState(() {
                      selectedUser = selectedFilters.containsKey("parent")
                          ? selectedFilters['parent']?.first
                          : null;
                    });
                  },
                ),
                SelectRelationship(
                  onFiltersChanged: (selectedFilters) {
                    selectedRelationship =
                        selectedFilters.containsKey('relationship')
                            ? selectedFilters['relationship']?.first
                            : null;
                  },
                ),
                SelectResidence(
                  onFiltersChanged: (selectedFilters) {
                    setState(() {
                      selectedResidence =
                          selectedFilters.containsKey("residences")
                              ? selectedFilters['residences']?.first
                              : null;
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
                    verticalPadding: 8.h,
                    label: ref.watch(addParentStepProvider) == 1
                        ? "Cancel"
                        : "Previous",
                    onTap: () {
                      if (ref.watch(addParentStepProvider) != 1) {
                        addParentController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        ref.read(addParentStepProvider.notifier).state--;
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
                    verticalPadding: 8.h,
                    label:
                        ref.watch(addParentStepProvider) == 3 ? "Save" : 'Next',
                    onTap: ref.watch(addParentStepProvider) == 3
                        ? () {
                            ref.read(parentProvider.notifier).addParent(
                                  parentModel: ParentModel(
                                      id: selectedUser!.id,
                                      firstName: selectedUser!.firstName,
                                      lastName: selectedUser!.lastName,
                                      avaterUrl: selectedUser!.avaterUrl,
                                      email: selectedUser!.email,
                                      relationship: selectedRelationship,
                                      residence: selectedResidence),
                                  childId: widget.currentUserId,
                                  callBack: () {
                                    context.pop();
                                  },
                                );
                          }
                        : () {
                            addParentController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            ref.read(addParentStepProvider.notifier).state++;
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
