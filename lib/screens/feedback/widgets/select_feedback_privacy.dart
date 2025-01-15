import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
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
      values: ['All', 'Private', 'Public', 'My Feedback'],
      labels: ['All', 'Private', 'Public', 'My Feedback'],
      allowMultipleSelection: false,
    ),
  ];

  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterContent(
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
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Feedback Limit",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                8.ph,
                Container(
                  height: 48.h,
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
            16.ph,
            Container(
              height: 48.h,
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
            16.ph,
          ],
        ),
      ),
    );
  }
}
