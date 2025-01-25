import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFeedbackPrivacy extends StatefulWidget {
  const SelectFeedbackPrivacy({
    super.key,
    this.onSelectPrivacy,
    this.onChangeFeedbackLimit,
    this.onChangeAnnonymous,
  });

  final void Function(String?)? onSelectPrivacy;
  final void Function(String?)? onChangeFeedbackLimit;
  final void Function(bool?)? onChangeAnnonymous;

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

  Map<String, Set<String>> selectedFilters = {};

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
              selectedFilters: selectedFilters,
              onFiltersChanged: (filters) {
                setState(() {
                  selectedFilters = filters;
                });
                widget.onSelectPrivacy!(filters['Privacy']?.first);
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
                TextFormField(
                  onChanged: widget.onChangeFeedbackLimit,
                  decoration: InputDecoration(
                    hintText: "Type here",
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: context.colors.pureWhite,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            16.ph,
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                  color: context.colors.pureWhite,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Send feedback annonymously",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  Switch(
                      value: isAnonymous,
                      onChanged: (val) {
                        setState(() {
                          isAnonymous = val;
                          widget.onChangeAnnonymous!(val);
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
