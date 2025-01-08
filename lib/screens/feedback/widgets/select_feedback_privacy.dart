import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter_bottom_sheet_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFeedbackPrivacy extends StatefulWidget {
  const SelectFeedbackPrivacy({
    super.key,
  });

  @override
  State<SelectFeedbackPrivacy> createState() => _SelectFeedbackPrivacyState();
}

class _SelectFeedbackPrivacyState extends State<SelectFeedbackPrivacy> {
  final sections = [
    FilterSection(
      title: 'Privacy',
      options: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: false, // Radio button behavior
    ),
  ];

  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FilterBottomSheetContent(
            hasHeader: false,
            hasSearchOption: false,
            sections: sections,
            initialFilters: const {},
            initialSliderValue: 50,
            onFiltersChanged: (filters) {
              Log.info('Filters updated: $filters');
            },
            onApply: () {
              Log.info('Filters applied');
            },
            onReset: () {
              Log.info('Filters reset');
            },
            hasActionButton: false,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Feedback Limit",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: context.colors.pureWhite,
                  ),
                  child: const Row(
                    children: [Text("10")],
                  ),
                )
              ],
            ),
          ),
          16.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: context.colors.pureWhite,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Send feedback anonymously"),
                  Switch(
                      value: isAnonymous,
                      onChanged: (val) {
                        setState(() {
                          isAnonymous = !isAnonymous;
                        });
                      })
                ],
              ),
            ),
          ),
          16.ph,
        ],
      ),
    );
  }
}
