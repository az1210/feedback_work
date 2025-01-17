import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPrinciple extends StatefulWidget {
  const SelectPrinciple({
    super.key,
  });

  @override
  State<SelectPrinciple> createState() => _SelectPrincipleState();
}

class _SelectPrincipleState extends State<SelectPrinciple> {
  final sections = [
    FilterSection(
      title: 'Select Principle',
      values: [
        'The Given Set',
        'Our Parent',
        'Operating Principle',
        'Main Set',
        'Mother Nature',
        'Show Actual Principle',
        'Show Derived Principle',
      ],
      labels: [
        'The Given Set',
        'Our Parent',
        'Operating Principle',
        'Main Set',
        'Mother Nature',
        'Show Actual Principle',
        'Show Derived Principle',
      ],
      allowMultipleSelection: false,
    ),
  ];

  Map<String, Set<String>> selectedFilters = {
    'Select Principle': {'The Given Set'}
  };

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
            16.ph,
          ],
        ),
      ),
    );
  }
}
